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
We need to implement the action code of th state STATE_TX_ACTIVE:
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
        STATE_TX_ACTIVE:
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

5. Bit counters tx: if sample_w begin
if !data_q[0] or bit_stuff_bit_w, ones_count_q will be assigned as 3'b0
else ones_count_q will increase 3'd1.
end

5. Shift registers: if sample_w begin
if bit_count_q equals to 3'd7, data_q will be assigned as utmi_data_out_i
else data_q will be addigned as {~bit_transition_w, data_q[7:1]}
end

6. Set rx_ready_q to 1'b0

7. if sample_w and bit_count_q == 3'd7 and !bit_stuff_bit_w and !send_eop_q set tx_ready_q to 1'b1,
else set to 1'b0.

8. EOP Pending: if !utmi_txvalid_i then send_eop_q will be assigned as 1'b1.

9. The Tx logic is if !data_q[0] or bit_stuff_bit_w,
then out_dp_q <= ~out_dp_q and out_dn_q <= ~out_dn_q.

GPT4:Below is the USB module code in C++, with arrays used to describe registers and C++ expressions for the logic:
'''
#define USB_CLK_FREQ     60000000
#define SAMPLE_RATE 3

#include<iostream>
using namespace std;

// I/O interfaces declaration
bool clk_i, rstn_i, utmi_txvalid_i, utmi_dppulldown_i, utmi_dmpulldown_i, usb_rx_rcv_i, usb_rx_dp_i, usb_rx_dn_i, usb_reset_assert_i;
short utmi_data_out_i, utmi_op_mode_i, utmi_xcvrselect_i;
bool utmi_termselect_i;
short utmi_data_in_o, utmi_linestate_o;
bool utmi_txready_o, utmi_rxvalid_o, utmi_rxactive_o, utmi_rxerror_o, usb_tx_dp_o, usb_tx_dn_o, usb_tx_oen_o, usb_reset_detect_o, usb_en_o;

// Register definitions
bool rx_dp_ms,rx_dn_ms,rxd_ms,rx_dp0_q,rx_dp1_q,rx_dp_q, rx_dn0_q,rx_dn1_q,rx_dn_q,rxd0_q,rxd1_q,rxd_q,rxd_last_q,rxd_last_j_q,rx_ready_q,tx_ready_q,adjust_delayed_q,rx_error_q,sync_j_detected_q,send_eop_q;
short bit_count_q, sample_cnt_q, ones_count_q;
short data_q;
enum State{STATE_TX_ACTIVE};
State state_q;

// I/O arrays initialization
short in_data_i[]={0,0,0,0,0,0,0,0}, in_data_o[]={0,0,0,0,0,0,0,0};
bool in_dp_w,in_dn_w,in_rx_w,in_j_w,in_k_w,in_se0_w,in_invalid_w,sample_w,bit_edge_w,bit_transition_w,bit_stuff_bit_w,next_is_bit_stuff_w,usb_reset_assert_w,in_dp_q[]={false,false}, in_dn_q[]={false,false}, rxd_q[]={false,false};

void usb_init(){
    state_q = STATE_TX_ACTIVE;
    // code here
}

void usb_update(){
    if (state_q == STATE_TX_ACTIVE)
    {
        //rx error detection
        rx_error_q = (ones_count_q == 7 || in_invalid_w && sample_w) ? true : false;
        
        //sample timer
        adjust_delayed_q ? adjust_delayed_q = false : (sample_cnt_q == SAMPLE_RATE ? sample_cnt_q = 0: sample_cnt_q++);
        
        //NRZI Receiver
        if (sample_w){ rxd_last_j_q = in_j_w; }

        //bit counters
        if (sample_w){ bit_count_q++; }

        //bit counters tx
        if(sample_w){
            (!data_q[0] or bit_stuff_bit_w) ? ones_count_q = 0 : ones_count_q++;
        }

        // shift registers
        if(sample_w){
        bit_count_q == 7 ? data_q = utmi_data_out_i : data_q = (bit_transition_w) | (data_q << 1); 
        }

        // set rx_ready_q 
        rx_ready_q = false;

        // set tx_ready_q 
        if(sample_w and bit_count_q == 7 and !bit_stuff_bit_w and !send_eop_q){ tx_ready_q = true; }
        else{ tx_ready_q = false; }
        
        // EOP Pending
        if(!utmi_txvalid_i){ send_eop_q = true; }

        //Tx logic
        if(!data_q[0] or bit_stuff_bit_w) {
            out_dp_q = !out_dp_q; 
            out_dn_q = !out_dn_q; 
        }
    }
}

int main() {
    usb_init();
    usb_update();
    return 0;
}
'''
This is a basic representation based on your instructions. Note that the connection points (the inputs and outputs) and the internal wiring is missing since these need to be customized for the specific system in which this USB module interacts. It is also recommended to refactor code for modularity later on.

Remember to add library files and compile settings depending on your development environment before running the code. Here, I assumed clk_i, rstn_i and other input signals are provided externally.