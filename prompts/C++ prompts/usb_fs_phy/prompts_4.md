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
We need to implement the action code of th state STATE_TX_SYNC:
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
        STATE_TX_SYNC:
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
1. if adjust_delayed_q then adjust_delayed_q wiil be set to 1'b0
2. else begin
if sample_cnt_q is equal to  SAMPLE_RATE then sample_cnt_q will be set to 3'b0
else will be set to be itself increse one
end
3. NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
4. Bit counters: if sample_w, set bit_count_q increase 3'd1
5. Shift registers: if sample_w begin
if bit_count_q equals to 3'd7, data_q will be assigned as utmi_data_out_i
else data_q will be addigned as {~bit_transition_w, data_q[7:1]}
end
6. Set rx_ready_q to 1'b0
7. if sample_w and bit_count_q == 3'd7 set tx_ready_q to 1'b1,
else set to 1'b0.
8. Do Tx: if sample_w then out dp assigned as data_q[0] and out dn assigned as ~data_q[0].

GPT4:From the provided verilog code, here's the C++ code mirroring the provided logic. Notice that a simple binary operation was used to mimic the bit-wise assignment from the verilog code.
'''
#include<bits/stdc++.h>
using namespace std;

#define USB_CLK_FREQ     60000000
#define STATE_W          3
#define SAMPLE_RATE      3

// Register definitions
bool rx_en_q;
bool out_dp_q;
bool out_dn_q;
int bit_count_q = 0;
int ones_count_q = 0;
int data_q = 0;
bool send_eop_q;
bool sync_j_detected_q;
bool rx_dp_ms;
bool rx_dn_ms;
bool rxd_ms;
bool rx_dp0_q;
bool rx_dn0_q;
bool rx_dp1_q;
bool rx_dn1_q;
bool rx_dp_q;
bool rx_dn_q;
bool rxd0_q;
bool rxd1_q;
bool rxd_q;
int state_q;
int next_state_r;
bool rx_error_q;
bool rxd_last_q;
int sample_cnt_q = 0;
bool adjust_delayed_q;
bool rxd_last_j_q;
bool rx_ready_q;
bool tx_ready_q;
int se0_cnt_q = 0;

// Wire definitions (replaced by variables)
bool in_dp_w;
bool in_dn_w;
bool in_rx_w;
bool in_j_w;
bool in_k_w;
bool in_se0_w;
bool in_invalid_w;
bool sample_w;
bool bit_edge_w;
bool bit_transition_w;
bool bit_stuff_bit_w;
bool next_is_bit_stuff_w;
bool usb_reset_assert_w;

// the implementation
void state_machine(){
    // 1. Rx Error Detection: Rx bit stuffing error
    rx_error_q = ones_count_q == 7 || in_invalid_w && sample_w ? 1 : 0;

    // 2. Sample Timer: Delayed adjustment
    if (adjust_delayed_q) {
        adjust_delayed_q = 0;
    } else {
        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
    }

    // 3. NRZI Receiver
    if (sample_w){
        rxd_last_j_q = in_j_w;
    }

    // 4. Bit counters
    if (sample_w){
        bit_count_q += 1;
    }

    // 5. Shift registers
    if (sample_w){
        if (bit_count_q == 7){
            data_q = utmi_data_out_i;
        } else{
            int bit_transition_w_aux = bit_transition_w ? 0 : 1;
            data_q = (bit_transition_w_aux << 7) | (data_q >> 1);
        }
    }

    // 6. Set rx_ready_q to 0
    rx_ready_q = 0;

    // 7. if sample_w and bit_count_q == 7 set tx_ready_q to 1, else set to 0.
    tx_ready_q = (sample_w && bit_count_q == 7) ? 1 : 0;

    //8. Do Tx
    if (sample_w){
        out_dp_q = data_q & 1;
        out_dn_q = (~data_q) & 1;
    }
}
'''
The C++ translation adopts a straightforward procedural style and uses integer and boolean variables instead of registers and wires. Note that bitwise operators and shift operators are used to reproduce the behaviors of the equivalent Verilog constructs. All actions are invoked inside a function named state_machine(), which should be called at every clock cycle to mirror the clocked behaviour of the original Verilog code.