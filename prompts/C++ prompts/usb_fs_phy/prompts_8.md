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
We need to implement the action code of th state STATE_IDLE:
'''
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
......
        STATE_IDLE:
// code here
......
        endcase
    end
end
'''

Here are the actions that should do:
1. Rx Error Detection: Rx bit stuffing error
if ones_count_q == 3'd7 or in_invalid_w && sample_w, the rx_error_q will be set to 1'b1, else set to 1'b0.

2. Sample Timer: Delayed adjustment
The Sample Timer action should be:
a. if adjust_delayed_q then adjust_delayed_q wiil be set to 1'b0
b. else if bit_edge_w and (sample_cnt_q != 3'd0) then sample_cnt_q will be set to 3'b0
c. else if bit_edge_w and (sample_cnt_q == 3'd0) then begin
adjust_delayed_q will be assigned as 1'b1.
if sample_cnt_q equal to SAMPLE_RATE then sample_cnt_q will set to 3'b0
else sample_cnt_q will increase 3'b1.
end
d. else begin
if sample_cnt_q equal to SAMPLE_RATE then sample_cnt_q will set to 3'b0
else sample_cnt_q will increase 3'b1.
end

3. NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w

4. Bit counters: 
the ones_count_q should be set to 3'b1
the bit_count_q should be set to 3'b0

5. Shift registers:
data_q will be assigned as 8'b00101010

6. Set tx_ready_q to 1'b0, rx_ready_q to 1'b0

7. Do Tx: IDLE
out dp will set to 1'b1 and out dn will set to 1'b0.
if utmi_txvalid_i or usb_reset_assert_w,
rx_en_q will set to be 1'b0, else set to be 1'b1.

GPT4:Okay, here is the C++ code to model the hardware behavior based on your description:
'''
// Define constants
const int STATE_IDLE = 0;
const int SAMPLE_RATE = 3;

// Declaring the input and output signals
bool clk_i, rstn_i, utmi_txvalid_i, usb_reset_assert_w;
bool in_invalid_w, sample_w, bit_edge_w, in_j_w;
int utmi_op_mode_i, utmi_linestate_o;
bool utmi_termselect_i, utmi_dppulldown_i, utmi_dmpulldown_i,
     usb_rx_rcv_i, usb_rx_dp_i, usb_rx_dn_i, usb_reset_assert_i;
int state_q = STATE_IDLE;

// Declare the register
bool sync_j_detected_q = false, rx_error_q = false,
     adjust_delayed_q = false, rxd_last_j_q = false,
     rx_ready_q = false, tx_ready_q = false, send_eop_q = false,
     rx_en_q = true, out_dp_q = false, out_dn_q = false;
         
int sample_cnt_q = 0, ones_count_q = 1, bit_count_q = 0;
std::bitset<8> data_q("00000000");

// The main function models STATE_IDLE behavior
void simulate() {
    // 1. Rx Error Detection
    rx_error_q = (ones_count_q == 7 || in_invalid_w) && sample_w;

    // 2. Sample Timer
    if (adjust_delayed_q) {
        adjust_delayed_q = false;
    }
    else if (bit_edge_w) {
        if (sample_cnt_q != 0) {
            sample_cnt_q = 0;
        }
        else {
            adjust_delayed_q = true;

            if (sample_cnt_q == SAMPLE_RATE) {
                sample_cnt_q = 0;
            }
            else {
                sample_cnt_q++;
            }
        }
    }
    else {
        if (sample_cnt_q == SAMPLE_RATE) {
            sample_cnt_q = 0;
        }
        else {
            sample_cnt_q++;
        }
    }

    // 3. NRZI Receiver
    if (sample_w) {
        rxd_last_j_q = in_j_w;
    }

    // 4. Bit Counter
    ones_count_q = 1;
    bit_count_q = 0;

    // 5. Shift registers
    data_q = std::bitset<8>("00101010");

    // 6. Control signals
    tx_ready_q = false;
    rx_ready_q = false;

    // 7. Do Tx
    out_dp_q = true;
    out_dn_q = false;

    if (utmi_txvalid_i || usb_reset_assert_w) {
        rx_en_q = false;
    } else {
        rx_en_q = true;
    }
}

int main() {
    simulate();
}
'''
This code is for the simulation of action code performed in the state STATE_IDLE only. We define the signals and states as bool or int variables. Each action is performed in order denoted, from 1 to 7, based on the condition (mainly if-else statements). Also, note that std::bitset has been used to hold 8 bits of data. For other states, the same structure can be adapted.
