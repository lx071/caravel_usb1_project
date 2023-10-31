module usb_fs_phy
//-----------------------------------------------------------------
// Params
//-----------------------------------------------------------------
#(
     parameter USB_CLK_FREQ     = 60000000
)

(
    // Inputs
     input           clk_i
    ,input           rstn_i
    ,input  [  7:0]  utmi_data_out_i  // rx data for utmi interface
    ,input           utmi_txvalid_i  // tx valid signal for utmi interface
    ,input  [  1:0]  utmi_op_mode_i // no driven, always be 2'b01
    ,input  [  1:0]  utmi_xcvrselect_i // usb ls, hs or fs
    ,input           utmi_termselect_i // 1'b0 for hs term enable, 1'b1 for fs term enable
    ,input           utmi_dppulldown_i 
    ,input           utmi_dmpulldown_i
    ,input           usb_rx_rcv_i
    ,input           usb_rx_dp_i
    ,input           usb_rx_dn_i
    ,input           usb_reset_assert_i

    // Outputs
    ,output [  7:0]  utmi_data_in_o // tx data for utmi interface
    ,output          utmi_txready_o // tx readuy signal for utmi interface
    ,output          utmi_rxvalid_o // rx valid signal for utmi interface
    ,output          utmi_rxactive_o // rx data prepartion signal for utmi interface
    ,output          utmi_rxerror_o // if error happens in rx
    ,output [  1:0]  utmi_linestate_o // 2'b00 for SE0, 2'b01 for J, 2'b10 for K, 2'b11 for SE1
    ,output          usb_tx_dp_o
    ,output          usb_tx_dn_o
    ,output          usb_tx_oen_o
    ,output          usb_reset_detect_o
    ,output          usb_en_o
);

localparam SAMPLE_RATE       = (USB_CLK_FREQ == 60000000) ? 3'd4 : 3'd3;
localparam STATE_W              = 4;
localparam STATE_IDLE           = 4'd0;
localparam STATE_RX_DETECT      = 4'd1;
localparam STATE_RX_SYNC_J      = 4'd2;
localparam STATE_RX_SYNC_K      = 4'd3;
localparam STATE_RX_ACTIVE      = 4'd4;
localparam STATE_RX_EOP0        = 4'd5;
localparam STATE_RX_EOP1        = 4'd6;
localparam STATE_TX_SYNC        = 4'd7;
localparam STATE_TX_ACTIVE      = 4'd8;
localparam STATE_TX_EOP_STUFF   = 4'd9;
localparam STATE_TX_EOP0        = 4'd10;
localparam STATE_TX_EOP1        = 4'd11;
localparam STATE_TX_EOP2        = 4'd12;
localparam STATE_TX_RST         = 4'd13;

// Register definitions
reg rx_en_q;
reg out_dp_q;
reg out_dn_q;
reg [2:0] bit_count_q;
reg [2:0] ones_count_q;
reg [7:0] data_q;
reg send_eop_q;
reg sync_j_detected_q;
reg rx_dp_ms;
reg rx_dn_ms;
reg rxd_ms;
reg rx_dp0_q;
reg rx_dn0_q;
reg rx_dp1_q;
reg rx_dn1_q;
reg rx_dp_q;
reg rx_dn_q;
reg rxd0_q;
reg rxd1_q;
reg rxd_q;
reg [STATE_W-1:0] state_q;
reg [STATE_W-1:0] next_state_r;
reg rx_error_q;
reg rxd_last_q;
reg [2:0] sample_cnt_q;
reg adjust_delayed_q;
reg rxd_last_j_q;
reg rx_ready_q;
reg tx_ready_q;
reg [6:0] se0_cnt_q;

// Wire definitions
wire in_dp_w;
wire in_dn_w;
wire in_rx_w;
wire in_j_w;
wire in_k_w;
wire in_se0_w;
wire in_invalid_w;
wire sample_w;
wire bit_edge_w;
wire bit_transition_w;
wire bit_stuff_bit_w;
wire next_is_bit_stuff_w;
wire usb_reset_assert_w = usb_reset_assert_i | 
                                (utmi_xcvrselect_i == 2'b00 && 
                                 utmi_termselect_i == 1'b0  && 
                                 utmi_op_mode_i    == 2'b10 && 
                                 utmi_dppulldown_i && 
                                 utmi_dmpulldown_i);

// Logic for the USB PHY to be implemented here
always @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i) begin
        rx_dp_ms <= 1'b0;
        rx_dn_ms <= 1'b0;
        rxd_ms   <= 1'b0;
    end else begin
        rx_dp_ms <= in_dp_w;
        rx_dn_ms <= in_dn_w;
        rxd_ms   <= in_rx_w;
    end
end

always @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i) begin
        rx_dp0_q <= 1'b0;
        rx_dn0_q <= 1'b0;
        rx_dp1_q <= 1'b0; 
        rx_dn1_q <= 1'b0; 
        rx_dp_q  <= 1'b0; 
        rx_dn_q  <= 1'b0; 
        rxd0_q   <= 1'b0; 
        rxd1_q   <= 1'b0;
        rxd_q    <= 1'b0;
        rxd_last_q  <= 1'b0;
        se0_cnt_q <= 7'b0;
    end else begin
        rx_dp_q <= (rx_dp0_q & rx_dp1_q) ? 1'b1 : (!rx_dp0_q & !rx_dp1_q) ? 1'b0 : rx_dp_q;
        rx_dn_q <= (rx_dn0_q & rx_dn1_q) ? 1'b1 : (!rx_dn0_q & !rx_dn1_q) ? 1'b0 : rx_dn_q;
        rxd_q   <= (rxd0_q & rxd1_q) ? 1'b1 : (!rxd0_q & !rxd1_q) ? 1'b0 : rxd_q;

        rx_dp1_q <= rx_dp0_q;
        rx_dp0_q <= rx_dp_ms;
        rx_dn1_q <= rx_dn0_q;
        rx_dn0_q <= rx_dn_ms; 
        rxd1_q   <= rxd0_q;
        rxd0_q   <= rxd_ms;
        rxd_last_q  <= in_j_w; // Edge Detector
        if (in_se0_w)
        begin
            if (se0_cnt_q != 7'd127)
                se0_cnt_q <= se0_cnt_q + 7'd1;
        end
        else
            se0_cnt_q <= 7'b0;
    end
end

always @*
begin
    next_state_r = state_q;

    case (state_q)

        STATE_IDLE:
        begin
            if (in_k_w)
                next_state_r = STATE_RX_DETECT;
            else if (utmi_txvalid_i)
                next_state_r = STATE_TX_SYNC;
            else if (usb_reset_assert_w)
                next_state_r = STATE_TX_RST;
        end

        STATE_RX_DETECT:
        begin
            if (in_k_w && sample_w)
                next_state_r = STATE_RX_SYNC_K;
            else if (sample_w)
                next_state_r = STATE_IDLE;
        end

        STATE_RX_SYNC_J:
        begin
            if (in_k_w && sample_w)
                next_state_r = STATE_RX_SYNC_K;
            else if ((bit_count_q == 3'd1) && sample_w)
                next_state_r = STATE_IDLE;
        end

        STATE_RX_SYNC_K:
        begin
            if (sync_j_detected_q && in_k_w && sample_w)
                next_state_r = STATE_RX_ACTIVE;
            else if (!sync_j_detected_q && in_k_w && sample_w)
                next_state_r = STATE_IDLE;
            else if (in_j_w && sample_w)
                next_state_r = STATE_RX_SYNC_J;
        end

        STATE_RX_ACTIVE:
        begin
            if (in_se0_w && sample_w)
                next_state_r = STATE_RX_EOP0;
            else if (in_invalid_w && sample_w)
                next_state_r = STATE_IDLE;
        end

        STATE_RX_EOP0:
        begin
            if (in_se0_w && sample_w)
                next_state_r = STATE_RX_EOP1;
            else if (sample_w)
                next_state_r = STATE_IDLE;
        end

        STATE_RX_EOP1:
        begin
            if (in_j_w && sample_w)
                next_state_r = STATE_IDLE;
            else if (sample_w)
                next_state_r = STATE_IDLE;
        end


        STATE_TX_SYNC:
        begin
            if (bit_count_q == 3'd7 && sample_w)
                next_state_r = STATE_TX_ACTIVE;
        end

        STATE_TX_ACTIVE:
        begin
            if (bit_count_q == 3'd7 && sample_w && (!utmi_txvalid_i || send_eop_q) && !bit_stuff_bit_w)
            begin
                if (next_is_bit_stuff_w)
                    next_state_r = STATE_TX_EOP_STUFF;
                else
                    next_state_r = STATE_TX_EOP0;
            end
        end

        STATE_TX_EOP_STUFF:
        begin
            if (sample_w)
                next_state_r = STATE_TX_EOP0;
        end

        STATE_TX_EOP0:
        begin
            if (sample_w)
                next_state_r = STATE_TX_EOP1;
        end

        STATE_TX_EOP1:
        begin
            if (sample_w)
                next_state_r = STATE_TX_EOP2;
        end

        STATE_TX_EOP2:
        begin
            if (sample_w)
                next_state_r = STATE_IDLE;
        end

        STATE_TX_RST:
        begin
            if (!usb_reset_assert_w)
                next_state_r = STATE_IDLE;
        end

        default:
            ;
    endcase
end

always @ (negedge rstn_i or posedge clk_i)
if (!rstn_i)
    state_q   <= STATE_IDLE;
else
    state_q   <= next_state_r;

always @ (posedge clk_i or negedge rstn_i)
begin
    if (!rstn_i)
    begin
        sync_j_detected_q  <= 1'b0;
        rx_error_q  <= 1'b0;
        sample_cnt_q        <= 3'd0;
        adjust_delayed_q    <= 1'b0;
        rxd_last_j_q  <= 1'b0;
        ones_count_q <= 3'd1;
        bit_count_q <= 3'b0;
        data_q  <= 8'b0;
        rx_ready_q <= 1'b0;
        tx_ready_q <= 1'b0;
        send_eop_q  <= 1'b0;
        out_dp_q <= 1'b0;
        out_dn_q <= 1'b0;
        rx_en_q  <= 1'b1;
    end
    else 
    begin
        case (state_q)

        STATE_IDLE:
        begin
            sync_j_detected_q  <= 1'b0;

            // Rx Error Detection: Rx bit stuffing error
            if ((ones_count_q == 3'd7) || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (bit_edge_w && (sample_cnt_q != 3'd0))
                sample_cnt_q <= 3'd0;
            else if (bit_edge_w && (sample_cnt_q == 3'd0))
            begin
                adjust_delayed_q <= 1'b1;
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver
            rxd_last_j_q <= in_j_w;

            // Bit counters
            ones_count_q <= 3'd1;
            bit_count_q <= 3'b0;

            // Shift registers
            data_q <= 8'b00101010;

            // Set tx_ready_q and rx_ready_q to 1'b0
            tx_ready_q <= 1'b0;
            rx_ready_q <= 1'b0;

            // Do Tx: IDLE
            out_dp_q <= 1'b1;
            out_dn_q <= 1'b0;

            // Rx Enable: IDLE
            if (utmi_txvalid_i || usb_reset_assert_w)
                rx_en_q <= 1'b0;
            else
                rx_en_q <= 1'b1;
        end

        STATE_TX_EOP_STUFF:
        begin
            // Rx Error Detection: Rx bit stuffing error
            if ((ones_count_q == 3'd7) || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver: Assign in_j_w to rxd_last_j_q if sample_w
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Set rx_ready_q and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;

            // Do Tx
            if (sample_w)
            begin
                // Tx logic
                if (!data_q[0] || bit_stuff_bit_w)
                begin
                    out_dp_q <= ~out_dp_q;
                    out_dn_q <= ~out_dn_q;
                end
            end
        end

        STATE_TX_EOP0:
        begin
            // Rx Error Detection: Rx bit stuffing error
            rx_error_q <= ((ones_count_q == 3'd7) || (in_invalid_w && sample_w)) ? 1'b1 : 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q  <= in_j_w;

            // Set rx_ready_q and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;

            // Set send_eop_q to 1'b0
            send_eop_q <= 1'b0;

            // Do Tx: if sample_w then transfer SE0
            if (sample_w)
            begin
                out_dp_q <= 1'b0;
                out_dn_q <= 1'b0;
            end
        end

        STATE_TX_EOP1:
        begin
            // Rx Error Detection: Rx bit stuffing error
            rx_error_q <= ((ones_count_q == 3'd7) || (in_invalid_w && sample_w)) ? 1'b1 : 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q  <= in_j_w;

            // Set rx_ready_q and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;

            // Do Tx: if sample_w then transfer SE0
            if (sample_w)
            begin
                out_dp_q <= 1'b0;
                out_dn_q <= 1'b0;
            end
        end

        STATE_TX_EOP2:
        begin
            // Rx Error Detection: Rx bit stuffing error
            rx_error_q <= ((ones_count_q == 3'd7) || (in_invalid_w && sample_w)) ? 1'b1 : 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q  <= in_j_w;

            // Set rx_ready_q and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;

            // Do Tx: if sample_w then transfer SE0
            if (sample_w)
            begin
                out_dp_q <= 1'b1; // Idle state
                out_dn_q <= 1'b0; // Idle state
                rx_en_q <= 1'b1; // Bus is free
            end
        end

        STATE_TX_RST:
        begin
            // Rx Error Detection: Rx bit stuffing error
            rx_error_q <= ((ones_count_q == 3'd7) || (in_invalid_w && sample_w)) ? 1'b1 : 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q  <= in_j_w;


            // Set rx_ready_q and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;

            // Do Tx: Output SE0
            out_dp_q <= 1'b0;
            out_dn_q <= 1'b0;
        end

        STATE_TX_SYNC:
        begin
            // Rx Error Detection: Rx bit stuffing error
            if (ones_count_q == 3'd7 || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;
            
            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end
                
            // NRZI Receiver
            if (sample_w)
                rxd_last_j_q <= in_j_w;
                
            // Bit counters
            if (sample_w)
                bit_count_q <= bit_count_q + 3'd1;
                
            // Shift registers
            if (sample_w) begin
                if (bit_count_q == 3'd7)
                    data_q <= utmi_data_out_i;
                else
                    data_q <= {~bit_transition_w, data_q[7:1]};
            end
                
            // Set rx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
                
            // Set tx_ready_q
            if (sample_w && bit_count_q == 3'd7)
                tx_ready_q <= 1'b1;
            else
                tx_ready_q <= 1'b0;
                
            // Do Tx
            if (sample_w) begin
                out_dp_q <= data_q[0];
                out_dn_q <= ~data_q[0];
            end
        end
        
        STATE_TX_ACTIVE:
        begin
            // Rx Error Detection: Rx bit stuffing error
            if (ones_count_q == 3'd7 || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (sample_cnt_q == SAMPLE_RATE)
                sample_cnt_q <= 'b0;
            else
                sample_cnt_q <= sample_cnt_q + 'd1;

            // NRZI Receiver
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Bit counters
            if (sample_w && !bit_stuff_bit_w)
                bit_count_q <= bit_count_q + 3'd1;

            // Bit counters tx
            if (sample_w)
            begin
                if (!data_q[0] || bit_stuff_bit_w)
                    ones_count_q <= 3'b0;
                else
                    ones_count_q <= ones_count_q + 3'd1;
            end

            // Shift registers
            if (sample_w && !bit_stuff_bit_w)
            begin
                if (bit_count_q == 3'd7)
                    data_q <= utmi_data_out_i;
                else
                    data_q <= {~bit_transition_w, data_q[7:1]};
            end

            // Set rx_ready_q to 1'b0
            rx_ready_q <= 1'b0;

            // Tx Ready
            if (sample_w && bit_count_q == 3'd7 && !bit_stuff_bit_w && !send_eop_q)
                tx_ready_q <= 1'b1;
            else
                tx_ready_q <= 1'b0;

            // EOP Pending
            if (!utmi_txvalid_i)
                send_eop_q <= 1'b1;

            // Tx logic
            if (sample_w && (!data_q[0] || bit_stuff_bit_w))
            begin
                out_dp_q <= ~out_dp_q;
                out_dn_q <= ~out_dn_q;
            end
        end
        
        STATE_RX_EOP0:
        begin
            // Rx Error Detection: Rx bit stuffing error
            if (ones_count_q == 3'd7 || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (bit_edge_w && (sample_cnt_q != 3'd0))
                sample_cnt_q <= 3'b0;
            else if (bit_edge_w && (sample_cnt_q == 3'd0))
            begin
                adjust_delayed_q <= 1'b1;
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Set rx_ready_q to 1'b0 and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;
        end

        STATE_RX_EOP1:
        begin
            // Rx Error Detection: Rx bit stuffing error
            if (ones_count_q == 3'd7 || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (bit_edge_w && (sample_cnt_q != 3'd0))
                sample_cnt_q <= 3'b0;
            else if (bit_edge_w && (sample_cnt_q == 3'd0))
            begin
                adjust_delayed_q <= 1'b1;
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'd1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Set rx_ready_q to 1'b0 and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;
        end

        STATE_RX_DETECT:
        begin
            // Rx Error Detection: Rx bit stuffing error
            if (ones_count_q == 3'd7 || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (bit_edge_w && (sample_cnt_q != 3'd0))
                sample_cnt_q <= 3'b0;
            else if (bit_edge_w && (sample_cnt_q == 3'd0))
            begin
                adjust_delayed_q <= 1'b1;
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Set rx_ready_q to 1'b0 and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;
        end

        STATE_RX_SYNC_J:
        begin
            // sync_j_detected_q is assigned as 1'b1
            sync_j_detected_q <= 1'b1;

            // Bit counters: if sample_w then bit_count_q will increase 3'b1
            if (sample_w)
                bit_count_q <= bit_count_q + 3'b1;

            // Rx Error Detection: Rx bit stuffing error
            if (ones_count_q == 3'd7 || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (bit_edge_w && (sample_cnt_q != 3'd0))
                sample_cnt_q <= 3'b0;
            else if (bit_edge_w && (sample_cnt_q == 3'd0))
            begin
                adjust_delayed_q <= 1'b1;
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Set rx_ready_q to 1'b0 and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;
        end

        STATE_RX_SYNC_K:
        begin
            // Bit counters: bit_count_q will be assigned as 3'b0
            bit_count_q <= 3'b0;

            // For Rx Error Detection: if !sync_j_detected_q and in_k_w and sample_w, then rx_error_q will be assigned as 1'b1
            if (!sync_j_detected_q && in_k_w && sample_w)
                rx_error_q <= 1'b1;
            else
            begin
                // Rx Error Detection: Rx bit stuffing error
                if (ones_count_q == 3'd7 || (in_invalid_w && sample_w))
                    rx_error_q <= 1'b1;
                else
                    rx_error_q <= 1'b0;
            end

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (bit_edge_w && (sample_cnt_q != 3'd0))
                sample_cnt_q <= 3'b0;
            else if (bit_edge_w && (sample_cnt_q == 3'd0))
            begin
                adjust_delayed_q <= 1'b1;
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end

            // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Set rx_ready_q to 1'b0 and tx_ready_q to 1'b0
            rx_ready_q <= 1'b0;
            tx_ready_q <= 1'b0;
        end

        STATE_RX_ACTIVE:
        begin
            // Rx Error Detection: Rx bit stuffing error
            if ((ones_count_q == 3'd7) || (in_invalid_w && sample_w))
                rx_error_q <= 1'b1;
            else
                rx_error_q <= 1'b0;

            // Sample Timer: Delayed adjustment
            if (adjust_delayed_q)
                adjust_delayed_q <= 1'b0;
            else if (bit_edge_w && (sample_cnt_q != 3'd0))
                sample_cnt_q <= 3'b0;
            else if (bit_edge_w && (sample_cnt_q == 3'd0))
            begin
                adjust_delayed_q <= 1'b1;
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end
            else
            begin
                if (sample_cnt_q == SAMPLE_RATE)
                    sample_cnt_q <= 'b0;
                else
                    sample_cnt_q <= sample_cnt_q + 'b1;
            end

            // NRZI Receiver
            if (sample_w)
                rxd_last_j_q <= in_j_w;

            // Bit counters
            if (sample_w && !bit_stuff_bit_w)
                bit_count_q <= bit_count_q + 3'b1;

            // Bit counters rx
            if (sample_w)
            begin
                if (bit_transition_w)
                    ones_count_q <= 3'b0;
                else
                    ones_count_q <= ones_count_q + 3'b1;
            end

            // Shift registers
            if (sample_w && !bit_stuff_bit_w)
                data_q <= {~bit_transition_w, data_q[7:1]};

            // Check if ready to receive
            if (sample_w && (bit_count_q == 3'd7) && !bit_stuff_bit_w)
                rx_ready_q <= 1'b1;
            else
                rx_ready_q <= 1'b0;

            // Set tx_ready_q to 1'b0
            tx_ready_q <= 1'b0;
        end

        default:
            ;
        endcase
    end
end


assign utmi_rxerror_o = rx_error_q;
assign bit_edge_w = rxd_last_q ^ in_j_w;
assign sample_w = (sample_cnt_q == 0);
assign bit_transition_w = sample_w ? (rxd_last_j_q ^ in_j_w) : 1'b0;
assign bit_stuff_bit_w = (ones_count_q == 6);
assign next_is_bit_stuff_w = (ones_count_q == 5) && !bit_transition_w;
assign utmi_rxactive_o = (state_q == STATE_RX_ACTIVE);
assign utmi_data_in_o = data_q;
assign utmi_rxvalid_o = rx_ready_q;
assign utmi_txready_o = tx_ready_q;
assign usb_reset_detect_o = (se0_cnt_q == 127);
assign usb_tx_oen_o = rx_en_q;
assign usb_tx_dp_o = out_dp_q;
assign usb_tx_dn_o = out_dn_q;
assign in_dp_w = usb_rx_dp_i;
assign in_dn_w = usb_rx_dn_i;
assign in_rx_w = usb_rx_rcv_i;
assign usb_en_o = utmi_termselect_i;
assign in_j_w = in_se0_w ? 1'b0 : rxd_q;
assign in_k_w = in_se0_w ? 1'b0 : ~rxd_q;
assign in_se0_w = (!rx_dp_q & !rx_dn_q);
assign in_invalid_w = (rx_dp_q & rx_dn_q);
assign utmi_linestate_o = usb_tx_oen_o ? {rx_dn_q, rx_dp_q} : {usb_tx_dn_o, usb_tx_dp_o};

endmodule


