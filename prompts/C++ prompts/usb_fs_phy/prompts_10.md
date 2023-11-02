User:Hello,I need you to generate a usb module using C++ language.Now I will describe the hardware structure with natural language and some verilog language,you are supposed to understand it and generate a hardware model using C++.Remember that you need to use arrays to describe registers and wires,and use C++ expressions to describe some logical operations.You need to follow my instructions as follows:
Given the I/O interfaces of the usb_fs_phy.v:
'''
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
wire usb_reset_assert_w;

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
    end
end
'''

We need to implement the action code of transitions from one state to another state:
'''
always @ *
begin
    next_state_r = state_q;

    case (state_q)
......
    STATE_NAME :
    begin
    // code here
    end
......
    default:
        ;
    endcase
end
'''

For STATE_TX_SYNC, if bit_count_q == 3'd7 and sample_w then
next state is STATE_TX_ACTIVE.

For STATE_TX_ACTIVE, if bit_count_q == 3'd7 and sample_w and (!utmi_txvalid_i or send_eop_q) and !bit_stuff_bit_w
begin
if next_is_bit_stuff_w then next state is STATE_TX_EOP_STUFF,
else next state is STATE_TX_EOP0.
end

For STATE_TX_EOP_STUFF, if sample_w then
next state is STATE_TX_EOP0.

For STATE_TX_EOP0, if sample_w then
next state is STATE_TX_EOP1.

For STATE_TX_EOP1, if sample_w then
next state is STATE_TX_EOP2.

For STATE_TX_EOP2, if sample_w then
next state is STATE_IDLE.

For STATE_TX_RST, if !usb_reset_assert_w then next state is STATE_IDLE.

Please generate the above state transitions code.

GPT4:Here is the required C++ code for the action code of transitions from one state to another state:
'''
enum State {
    STATE_TX_SYNC,
    STATE_TX_ACTIVE,
    STATE_TX_EOP_STUFF,
    STATE_TX_EOP0,
    STATE_TX_EOP1,
    STATE_TX_EOP2,
    STATE_IDLE,
    STATE_TX_RST
};

State state_q = STATE_IDLE;
State next_state_r = STATE_IDLE;

bool bit_count_q[3] = {false, false, false};
bool sample_w = false;
bool utmi_txvalid_i = false;
bool send_eop_q = false;
bool bit_stuff_bit_w = false;
bool next_is_bit_stuff_w = false;
bool usb_reset_assert_w = false;

void nextState() {
    next_state_r = state_q;

    switch (state_q) {
      case STATE_TX_SYNC:
        if (bit_count_q[0] && bit_count_q[1] && bit_count_q[2] && sample_w)
            next_state_r = STATE_TX_ACTIVE;
        break;
      case STATE_TX_ACTIVE:
        if (bit_count_q[0] && bit_count_q[1] && bit_count_q[2] && sample_w && (!utmi_txvalid_i || send_eop_q) && !bit_stuff_bit_w)
        {
            if(next_is_bit_stuff_w) 
                next_state_r = STATE_TX_EOP_STUFF;
            else 
                next_state_r = STATE_TX_EOP0;
        }
        break;
      case STATE_TX_EOP_STUFF:
        if(sample_w)
            next_state_r = STATE_TX_EOP0;
        break;
      case STATE_TX_EOP0:
        if(sample_w)
            next_state_r = STATE_TX_EOP1;
        break;
      case STATE_TX_EOP1:
        if(sample_w)
            next_state_r = STATE_TX_EOP2;
        break;
      case STATE_TX_EOP2:
        if(sample_w)
            next_state_r = STATE_IDLE;
        break;
      case STATE_TX_RST:
        if(!usb_reset_assert_w)
            next_state_r = STATE_IDLE;
        break;
      default:
        break;
    }
}
'''
The above code represents a state machine in C++. It's a simplified representation of the state machine compared to hardware description languages like Verilog. However, it extracts and encapsulates the core sequence of state transitions based on the given conditions.

As some of the other conditions and variables remain unclear, placeholders (false / 0) are used.

Please replace them accordingly for a functioning state machine.