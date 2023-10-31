module usbh_sie #(
    parameter USB_CLK_FREQ = 60000000
) (
    // Inputs
    input wire clk_i,
    input wire rstn_i,
    input wire start_i,
    input wire in_transfer_i,
    input wire sof_transfer_i,
    input wire resp_expected_i,
    input wire [7:0] token_pid_i,
    input wire [6:0] token_dev_i,
    input wire [3:0] token_ep_i,
    input wire [15:0] data_len_i,
    input wire data_idx_i,
    input wire [7:0] tx_data_i,
    input wire utmi_txready_i,
    input wire [7:0] utmi_data_i,
    input wire utmi_rxvalid_i,
    input wire utmi_rxactive_i,
    input wire [1:0] utmi_linestate_i,

    // Outputs
    output wire ack_o,
    output wire tx_pop_o,
    output wire [7:0] rx_data_o,
    output wire rx_push_o,
    output wire tx_done_o,
    output wire rx_done_o,
    output wire crc_err_o,
    output wire timeout_o,
    output wire [7:0] response_o,
    output wire [15:0] rx_count_o,
    output wire idle_o,
    output wire [7:0] utmi_data_o,
    output wire utmi_txvalid_o
);

    // Define the registers
    reg start_ack_q;
    reg status_tx_done_q;
    reg status_rx_done_q;
    reg status_crc_err_q;
    reg status_timeout_q;
    reg [7:0] status_response_q;
    reg [15:0] byte_count_q;
    reg in_transfer_q;
    reg [7:0] last_tx_time_q;
    reg send_data1_q;
    reg send_sof_q;
    reg send_ack_q;
    reg [15:0] crc_sum_q;
    reg [15:0] token_q;
    reg wait_resp_q;
    reg [3:0] state_q;

    // Define the wires
    wire [15:0] crc_out_w;
    wire [7:0] crc_data_in_w;
    wire [4:0] crc5_out_w;
    wire [4:0] crc5_next_w;

    // Calculate the CRC5 next value
    assign crc5_next_w = crc5_out_w ^ 5'h1F;

    // Definitions of constants
    localparam RX_TIMEOUT = (USB_CLK_FREQ == 60000000) ? 9'd511 : 9'd255;
    localparam TX_IFS = (USB_CLK_FREQ == 60000000) ? 4'd10 : 4'd7;

    localparam PID_OUT = 8'hE1;
    localparam PID_IN = 8'h69;
    localparam PID_SOF = 8'hA5;
    localparam PID_SETUP = 8'h2D;
    localparam PID_DATA0 = 8'hC3;
    localparam PID_DATA1 = 8'h4B;
    localparam PID_ACK = 8'hD2;
    localparam PID_NAK = 8'h5A;
    localparam PID_STALL = 8'h1E;

    // States for the state machine
    localparam STATE_IDLE = 4'd0;
    localparam STATE_RX_DATA = 4'd1;
    localparam STATE_TX_PID = 4'd2;
    localparam STATE_TX_DATA = 4'd3;
    localparam STATE_TX_CRC1 = 4'd4;
    localparam STATE_TX_CRC2 = 4'd5;
    localparam STATE_TX_TOKEN1 = 4'd6;
    localparam STATE_TX_TOKEN2 = 4'd7;
    localparam STATE_TX_TOKEN3 = 4'd8;
    localparam STATE_TX_ACKNAK = 4'd9;
    localparam STATE_TX_WAIT = 4'd10;
    localparam STATE_RX_WAIT = 4'd11;
    localparam STATE_TX_IFS = 4'd12;

    // Define the additional registers
    reg [1:0] utmi_linestate_q;
    reg se0_detect_q;
    reg wait_eop_q;
    reg [31:0] data_buffer_q;
    reg [3:0] data_valid_q;
    reg [3:0] rx_active_q;
    reg [1:0] data_crc_q;
    reg [3:0] next_state_q;

    // Define TX_IFS_W constant and tx_ifs register
    localparam TX_IFS_W = 4;
    reg [TX_IFS_W-1:0] tx_ifs_q;

    // Additional wire and register definitions
    wire [7:0] rx_data_w;
    wire data_ready_w;
    wire crc_byte_w;
    wire rx_active_w;
    wire rx_active_rise_w;

    // Tx/Rx IFS timeout
    wire ifs_busy_w;
    wire rx_resp_timeout_w = (last_tx_time_q >= RX_TIMEOUT) && wait_resp_q;

    // SE0 condition detection
    wire se0_detect_w = utmi_linestate_i == 2'b00 && utmi_linestate_q == 2'b00;

    // EOP detection
    wire eop_detected_w = se0_detect_q && utmi_linestate_i != 2'b00;

    // Generate shift_enable wire
    wire shift_en_w = utmi_rxvalid_i && utmi_rxactive_i || !utmi_rxactive_i;

    // CRC16 error condition detection
    wire crc_error_w = state_q == STATE_RX_DATA && !rx_active_w && in_transfer_q && (status_response_q == PID_DATA0 || status_response_q == PID_DATA1) && crc_sum_q != 16'hB001;

    always @(*) begin
        next_state_q = state_q;  // assign the current state to next_state
        case(state_q)

            STATE_TX_TOKEN1: if (utmi_txready_i) next_state_q = STATE_TX_TOKEN2;

            STATE_TX_TOKEN2: if (utmi_txready_i) next_state_q = STATE_TX_TOKEN3;

            STATE_TX_TOKEN3: begin
                if (utmi_txready_i) begin
                    if (send_sof_q) next_state_q = STATE_TX_IFS;
                    else if (in_transfer_q) next_state_q = STATE_RX_WAIT;
                    else next_state_q = STATE_TX_IFS;
                end
            end

            STATE_TX_IFS: begin
                if (!ifs_busy_w) begin
                    if (send_sof_q) next_state_q = STATE_IDLE;
                    else next_state_q = STATE_TX_PID;
                end
            end

            STATE_TX_PID: begin
                if (utmi_txready_i && byte_count_q == 0) next_state_q = STATE_TX_CRC1;
                else if (utmi_txready_i) next_state_q = STATE_TX_DATA;
            end

            STATE_TX_DATA: if (utmi_txready_i && byte_count_q == 0) next_state_q = STATE_TX_CRC1;

            STATE_TX_CRC1: if (utmi_txready_i) next_state_q = STATE_TX_CRC2;

            STATE_TX_CRC2: begin
                if (utmi_txready_i) begin
                    if (wait_resp_q) next_state_q = STATE_RX_WAIT;
                    else next_state_q = STATE_IDLE;
                end
            end

            STATE_TX_WAIT: if (!ifs_busy_w) next_state_q = STATE_TX_ACKNAK;

            STATE_TX_ACKNAK: if (utmi_txready_i) next_state_q = STATE_IDLE;

            STATE_RX_WAIT: begin
                if (data_ready_w) next_state_q = STATE_RX_DATA;
                else if (rx_resp_timeout_w) next_state_q = STATE_IDLE;
            end

            STATE_RX_DATA: begin
                if (!rx_active_w) begin
                    if (send_ack_q & crc_error_w) next_state_q = STATE_IDLE;
                    else if (send_ack_q & (status_response_q == PID_DATA0 || status_response_q == PID_DATA1)) next_state_q = STATE_TX_WAIT;
                    else next_state_q = STATE_IDLE;
                end
            end

            STATE_IDLE: if (start_i) next_state_q = STATE_TX_TOKEN1;

            default: next_state_q = STATE_IDLE;

        endcase
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
        // Reset all the registers, where except crc_sum_q is set to 16'hffff, the rest are set to 0.
        start_ack_q <= 0;
        status_tx_done_q <= 0;
        status_rx_done_q <= 0;
        status_crc_err_q <= 0;
        status_timeout_q <= 0;
        status_response_q <= 0;
        byte_count_q <= 0;
        in_transfer_q <= 0;
        last_tx_time_q <= 0;
        send_data1_q <= 0;
        send_sof_q <= 0;
        send_ack_q <= 0;
        crc_sum_q <= 16'hffff;
        token_q <= 0;
        wait_resp_q <= 0;
        state_q <= 0;
        utmi_linestate_q <= 0;
        se0_detect_q <= 0;
        wait_eop_q <= 0;
        data_buffer_q <= 0;
        data_valid_q <= 0;
        rx_active_q <= 0;
        data_crc_q <= 0;
        next_state_q <= 0;
        tx_ifs_q <= 0;
        end else begin
        // update utmi_linestate and se0_detect
        utmi_linestate_q <= utmi_linestate_i;
        se0_detect_q <= utmi_linestate_i == 2'b00 && utmi_linestate_q == 2'b00;

        // update rx_active
        rx_active_q <= {utmi_rxactive_i, rx_active_q[3:1]};

        // update tx_ifs
        if (wait_eop_q || eop_detected_w)
            tx_ifs_q <= TX_IFS;
        else if (tx_ifs_q != 0)
            tx_ifs_q <= tx_ifs_q - 1;

        // check shift_enable and update registers
        if (shift_en_w) begin
            data_buffer_q <= {utmi_data_i, data_buffer_q[31:8]};
            data_valid_q <= {(utmi_rxvalid_i & utmi_rxactive_i), data_valid_q[3:1]};
            data_crc_q <= {!utmi_rxactive_i, data_crc_q[1]};
        end
        else
            data_valid_q <= {data_valid_q[3:1], 1'b0};
        end
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
        state_q <= STATE_IDLE; // Reset state to IDLE when reset is asserted
        // Other register resets can be defined here
        end else begin
        state_q <= next_state_q; // Move to next state with each clock pulse
        end
    end

    always @(posedge clk_i) begin
    case(state_q)

        STATE_IDLE: begin
            // update token register
            token_q <= {token_dev_i, token_ep_i, 5'b0};
            last_tx_time_q <= 0;
            start_ack_q <= 0;
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;

            // complete end of detection
            if (eop_detected_w) wait_eop_q <= 1'b0;
            else if (rx_active_rise_w) wait_eop_q <= 1'b1;

            // check start
            if (start_i) begin
                in_transfer_q <= in_transfer_i;
                send_ack_q <= in_transfer_i & resp_expected_i;
                send_data1_q <= data_idx_i;
                send_sof_q <= sof_transfer_i;
                wait_resp_q <= resp_expected_i;
                if (!sof_transfer_i) begin
                    byte_count_q <= data_len_i;
                    status_response_q <= 0;
                    status_timeout_q <= 0;
                    status_crc_err_q <= 0;
                end
            end
        end

        STATE_TX_TOKEN1: begin
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;

            // complete end of detection
            if (eop_detected_w) wait_eop_q <= 1'b0;
            else if (rx_active_rise_w) wait_eop_q <= 1'b1;

            // check utmi_txready
            if(utmi_txready_i) start_ack_q <= 1'b1;
            else start_ack_q <= 1'b0;

            // update token register
            if (utmi_txready_i) token_q[4:0] <= crc5_next_w;

            // check time since last transmit
            if (utmi_txready_i && utmi_txvalid_o) last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT) last_tx_time_q <= last_tx_time_q + 1;
        end

        STATE_TX_TOKEN2: begin
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;

            if (eop_detected_w) wait_eop_q <= 0;
            else if (rx_active_rise_w) wait_eop_q <= 1;

            if (utmi_txready_i && utmi_txvalid_o) last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT) last_tx_time_q <= last_tx_time_q + 1;
        end

        STATE_TX_TOKEN3: begin
            // reset some registers
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;

            // end detection
            if (eop_detected_w)
                wait_eop_q <= 0;
            else if (rx_active_rise_w || next_state_q != STATE_TX_TOKEN3)
                wait_eop_q <= 1;

            // handling data sent conditions
            if (utmi_txready_i && utmi_txvalid_o)
                last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT)
                last_tx_time_q <= last_tx_time_q + 1;
        end

        STATE_TX_IFS: begin
            // reset some registers
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;

            // end of packet detection
            if (eop_detected_w)
                wait_eop_q <= 0;
            else if (rx_active_rise_w)
                wait_eop_q <= 1;

            // handling data sent conditions
            if (utmi_txready_i && utmi_txvalid_o)
                last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT)
                last_tx_time_q <= last_tx_time_q + 1;
        end

        STATE_TX_PID: begin
            // Reset some registers
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;
            crc_sum_q <= 16'hFFFF;

            // End detection
            if (eop_detected_w)
                wait_eop_q <= 0;
            else if (rx_active_rise_w)
                wait_eop_q <= 1;

            // Handling data sent conditions
            if (utmi_txready_i && utmi_txvalid_o)
                last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT)
                last_tx_time_q <= last_tx_time_q + 1;

            // Decrease byte_count if utmi_txready is set and byte_count is not zero
            if (utmi_txready_i && byte_count_q != 0)
                byte_count_q <= byte_count_q - 1;
        end

        STATE_TX_DATA: begin
            // reset some registers
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;

            // CRC output
            if (utmi_txready_i)
                crc_sum_q <= crc_out_w;

            // end detection
            if (eop_detected_w)
                wait_eop_q <= 0;
            else if (rx_active_rise_w)
                wait_eop_q <= 1;

            // handling data sent conditions
            if (utmi_txready_i && utmi_txvalid_o)
                last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT)
                last_tx_time_q <= last_tx_time_q + 1;

            // decrease byte_count when data sent
            if (utmi_txready_i && byte_count_q != 0)
                byte_count_q <= byte_count_q - 1;
        end

        STATE_TX_CRC1: begin
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;

            if(eop_detected_w) wait_eop_q <= 0;
            else if(rx_active_rise_w) wait_eop_q <= 1;

            if(utmi_txready_i && utmi_txvalid_o) last_tx_time_q <= 0;
            else if(last_tx_time_q != RX_TIMEOUT) last_tx_time_q <= last_tx_time_q + 1;
        end

        STATE_TX_CRC2: begin
            // Resetting appropriate flags
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;

            // End of detection
            if(eop_detected_w) begin
                wait_eop_q <= 0;
            end else if(rx_active_rise_w || next_state_q != STATE_TX_CRC2) begin
                wait_eop_q <= 1;
            end

            // Check for utmi_txready_i and utmi_txvalid_o
            if(utmi_txready_i && utmi_txvalid_o) begin
                last_tx_time_q <= 0;
            end else if(last_tx_time_q != RX_TIMEOUT) begin
                last_tx_time_q <= last_tx_time_q + 1;
            end

            // Set status_tx_done_q if conditions are met
            if(utmi_txready_i && !wait_resp_q) begin
                status_tx_done_q <= 1;
            end
        end

        STATE_TX_WAIT: begin
            // Resetting appropriate flags
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;
            start_ack_q <= 0;

            // End of detection
            if (eop_detected_w) begin
                wait_eop_q <= 0;
            end else if (rx_active_rise_w) begin
                wait_eop_q <= 1;
            end

            //  Checking utmi_txready_i and utmi_txvalid_o
            if (utmi_txready_i && utmi_txvalid_o) begin
                last_tx_time_q <= 0;
            end else if (last_tx_time_q != RX_TIMEOUT) begin
                last_tx_time_q <= last_tx_time_q + 1;
            end
        end

        STATE_TX_ACKNAK: begin
            start_ack_q <= 0;
            status_rx_done_q <= 0;
            status_tx_done_q <= 0;

            // Detect the end
            if (eop_detected_w)
                wait_eop_q <= 0;
            else if (rx_active_rise_w || next_state_q != STATE_TX_ACKNAK)
                wait_eop_q <= 1;

            // Check if utmi_txready_i and utmi_txvalid_o are set
            if (utmi_txready_i && utmi_txvalid_o)
                last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT)
                last_tx_time_q <= last_tx_time_q + 1;
        end

        STATE_RX_WAIT: begin
            start_ack_q <= 0;
            byte_count_q <= 0;
            status_tx_done_q <= 0;

            // Reset crc_sum_q
            crc_sum_q <= 16'hFFFF;

            // Detect the end
            if(eop_detected_w)
                wait_eop_q <= 0;
            else if (rx_active_rise_w)
                wait_eop_q <= 1;

            // Check if utmi_txready_i and utmi_txvalid_o are set
            if(utmi_txready_i && utmi_txvalid_o)
                last_tx_time_q <= 0;
            else if (last_tx_time_q != RX_TIMEOUT)
            last_tx_time_q <= last_tx_time_q + 1;

            // If data_ready_w is set
            if(data_ready_w) begin
                status_response_q <= rx_data_w;
                wait_resp_q <= 0;
            end

            // If rx_resp_timeout_w is set
            if(rx_resp_timeout_w)
                status_timeout_q <= 1;
        end

        STATE_RX_DATA: begin
            start_ack_q <= 0;

            // end of detection
            if (eop_detected_w) wait_eop_q <= 0;
            else if (rx_active_rise_w) wait_eop_q <= 1;

            // Update last_tx_time_q
            if(utmi_txready_i && utmi_txvalid_o) last_tx_time_q <= 0;
            else if(last_tx_time_q != RX_TIMEOUT) last_tx_time_q <= last_tx_time_q + 1;

            // Update status_rx_done_q
            if(utmi_rxactive_i) status_rx_done_q <= 0;
            else status_rx_done_q <= 1;

            // Byte count update and crc logic
            if (data_ready_w && !crc_byte_w) byte_count_q <= byte_count_q + 1;
            if (data_ready_w) crc_sum_q <= crc_out_w;
            else if(!rx_active_w) status_crc_err_q <= crc_error_w;

        end
        // Other states go here...

        endcase
    end
    // Assignments
    assign ifs_busy_w = wait_eop_q || (tx_ifs_q != {(TX_IFS_W){1'b0}});
    assign rx_data_w = data_buffer_q[7:0];
    assign data_ready_w = data_valid_q[0];
    assign crc_byte_w = data_crc_q[0];
    assign rx_active_w = rx_active_q[0];
    assign rx_active_rise_w = (!rx_active_q[3]) && utmi_rxactive_i;

    // CRC Objects
    usbh_crc16 u_crc16 (
        .crc_i(crc_sum_q),
        .data_i(crc_data_in_w),
        .crc_o(crc_out_w)
    );

    usbh_crc5 u_crc5 (
        .crc_i(5'h1F),
        .data_i(token_q[15:5]),
        .crc_o(crc5_out_w)
    );

    wire [15:0] token_rev_w;
    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : TOKEN_LOOP
        assign token_rev_w[i] = token_q[15 - i];
        end
    endgenerate

    reg utmi_txvalid_r;
    reg [7:0] utmi_data_r;

    always @* begin
        case (state_q)
        STATE_TX_CRC1: begin
            utmi_txvalid_r = 1'b1;
            utmi_data_r = crc_sum_q[7:0] ^ 8'hFF;
        end
        STATE_TX_CRC2: begin
            utmi_txvalid_r = 1'b1;
            utmi_data_r = crc_sum_q[15:8] ^ 8'hFF;
        end
        STATE_TX_TOKEN1: begin
            utmi_txvalid_r = 1'b1;
            utmi_data_r = token_pid_i;
        end
        STATE_TX_TOKEN2: begin
            utmi_txvalid_r = 1'b1;
            utmi_data_r = token_rev_w[7:0];
        end
        STATE_TX_TOKEN3: begin
            utmi_txvalid_r = 1'b1;
            utmi_data_r = token_rev_w[15:8];
        end
        STATE_TX_PID: begin
            utmi_txvalid_r = 1'b1;
            if (send_data1_q)
            utmi_data_r = PID_DATA1;
            else
            utmi_data_r = PID_DATA0;
        end
        STATE_TX_ACKNAK: begin
            utmi_txvalid_r = 1'b1;
            utmi_data_r = PID_ACK;
        end
        STATE_TX_DATA: begin
            utmi_txvalid_r = 1'b1;
            utmi_data_r = tx_data_i;
        end
        default: begin
            utmi_txvalid_r = 1'b0;
            utmi_data_r = 8'b0;
        end
        endcase
    end

    assign utmi_txvalid_o = utmi_txvalid_r;
    assign utmi_data_o = utmi_data_r;
    assign rx_data_o = rx_data_w;
    assign rx_push_o = data_ready_w & !crc_byte_w & ((state_q != STATE_IDLE) && (state_q != STATE_RX_WAIT));
    assign crc_data_in_w = (state_q == STATE_RX_DATA) ? rx_data_w : tx_data_i;
    assign rx_count_o = byte_count_q;
    assign idle_o = (state_q == STATE_IDLE);
    assign ack_o = start_ack_q;
    assign tx_pop_o = (state_q == STATE_TX_DATA) && utmi_txready_i;
    assign tx_done_o = status_tx_done_q;
    assign rx_done_o = status_rx_done_q;
    assign crc_err_o = status_crc_err_q;
    assign timeout_o = status_timeout_q;
    assign response_o = status_response_q;

endmodule

