#define USB_CLK_FREQ 60000000
#define SAMPLE_RATE (USB_CLK_FREQ == 60000000) ? 4 : 3
#define STATE_W 4
#define STATE_IDLE 0
#define STATE_RX_DETECT 1
#define STATE_RX_SYNC_J 2
#define STATE_RX_SYNC_K 3
#define STATE_RX_ACTIVE 4
#define STATE_RX_EOP0 5
#define STATE_RX_EOP1 6
#define STATE_TX_SYNC 7
#define STATE_TX_ACTIVE 8
#define STATE_TX_EOP_STUFF 9
#define STATE_TX_EOP0 10
#define STATE_TX_EOP1 11
#define STATE_TX_EOP2 12
#define STATE_TX_RST 13
class USB_FS_PHY {

public:

    // Clock and reset
    bool clk_i;
    bool rstn_i;

    // Other inputs (using least significant bit indexing)
    int utmi_data_out_i;
    bool utmi_txvalid_i;
    int utmi_op_mode_i;
    int utmi_xcvrselect_i;
    bool utmi_termselect_i;
    bool utmi_dppulldown_i;
    bool utmi_dmpulldown_i;
    bool usb_rx_rcv_i;
    bool usb_rx_dp_i;
    bool usb_rx_dn_i;
    bool usb_reset_assert_i;

    // Outputs
    int utmi_data_in_o;
    bool utmi_txready_o;
    bool utmi_rxvalid_o;
    bool utmi_rxactive_o;
    bool utmi_rxerror_o;
    int utmi_linestate_o;
    bool usb_tx_dp_o;
    bool usb_tx_dn_o;
    bool usb_tx_oen_o;
    bool usb_reset_detect_o;
    bool usb_en_o;

   // Register definitions
    bool rx_en_q;
    bool out_dp_q;
    bool out_dn_q;
    int bit_count_q;
    int ones_count_q;
    unsigned char data_q;
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
    int sample_cnt_q;
    bool adjust_delayed_q;
    bool rxd_last_j_q;
    bool rx_ready_q;
    bool tx_ready_q;
    int se0_cnt_q;

    // Wires
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
    bool bit_stuff_bit_w, next_is_bit_stuff_w, usb_reset_assert_w;

    // Not all registers and wires are declared in this simplified model.
    // Please add more registers and wires as necessary.

    USB_FS_PHY() {
        // Initialize inputs, outputs, and registers
        clk_i = false;
        rstn_i = false;
        rx_dp0_q = false;
        rx_dn0_q = false;
        rx_dp1_q = false;
        rx_dn1_q = false;
        rx_dp_q = false;
        rx_dn_q = false;
        rxd0_q = false;
        rxd1_q = false;
        rxd_q = false;
    }

    void updateRxValues() {
        if (!rstn_i) {
            rx_dp0_q = false;
            rx_dn0_q = false;
            rx_dp1_q = false;
            rx_dn1_q = false;
            rx_dp_q = false;
            rx_dn_q = false;
            rxd0_q = false;
            rxd1_q = false;
            rxd_q = false;
            se0_cnt_q = 0;
        } else if (clk_i) {
            if(rx_dp0_q && rx_dp1_q) rx_dp_q = true;
            else if (!rx_dp0_q && !rx_dp1_q) rx_dp_q = false;

            if(rx_dn0_q && rx_dn1_q) rx_dn_q = true;
            else if (!rx_dn0_q && !rx_dn1_q) rx_dn_q = false;

            if(rxd0_q && rxd1_q) rxd_q = true;
            else if (!rxd0_q && !rxd1_q) rxd_q = false;

            rx_dp1_q = rx_dp0_q;
            rx_dp0_q = rx_dp_ms;

            rx_dn1_q = rx_dn0_q;
            rx_dn0_q = rx_dn_ms;

            rxd1_q = rxd0_q;
            rxd0_q = rxd_ms;
            if (in_se0_w)
            {
                if (se0_cnt_q != 127) se0_cnt_q++;
            }
            else se0_cnt_q = 0;
        }
    }
    void transition_conditions()
    {
        next_state_r = state_q;

        switch (state_q)
        {
            case STATE_IDLE:
                if (in_k_w) next_state_r = STATE_RX_DETECT;
                else if (utmi_txvalid_i) next_state_r = STATE_TX_SYNC;
                else if (usb_reset_assert_w) next_state_r = STATE_TX_RST;
                break;

            case STATE_RX_DETECT:
                if (in_k_w && sample_w) next_state_r = STATE_RX_SYNC_K;
                else if (sample_w) next_state_r = STATE_IDLE;
                break;

            case STATE_RX_SYNC_J:
                if (in_k_w && sample_w) next_state_r = STATE_RX_SYNC_K;
                else if ((bit_count_q == 1) && sample_w) next_state_r = STATE_IDLE;
                break;

            case STATE_RX_SYNC_K:
                if (sync_j_detected_q && in_k_w && sample_w) next_state_r = STATE_RX_ACTIVE;
                else if (!sync_j_detected_q && in_k_w && sample_w) next_state_r = STATE_IDLE;
                else if (in_j_w && sample_w) next_state_r = STATE_RX_SYNC_J;
                break;

            case STATE_RX_ACTIVE:
                if (in_se0_w && sample_w) next_state_r = STATE_RX_EOP0;
                else if (in_invalid_w && sample_w) next_state_r = STATE_IDLE;
                break;

            case STATE_RX_EOP0:
                if (in_se0_w && sample_w) next_state_r = STATE_RX_EOP1;
                else if (sample_w) next_state_r = STATE_IDLE;
                break;

            case STATE_RX_EOP1:
                if (in_j_w && sample_w) next_state_r = STATE_IDLE;
                else if (sample_w) next_state_r = STATE_IDLE;
                break;
            case STATE_TX_RST:
                if(!usb_reset_assert_w)
                    next_state_r = STATE_IDLE;
                break;
            case STATE_TX_SYNC:
                if (bit_count_q == 7 && sample_w)
                    next_state_r = STATE_TX_ACTIVE;
                break;
            case STATE_TX_ACTIVE:
                if (bit_count_q == 7 && sample_w && (!utmi_txvalid_i || send_eop_q) && !bit_stuff_bit_w)
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
            default:
                break;
        }
    }
    void stateUpdateLogic(bool rx_error_q, bool rxd_last_j_q, bool sample_w, int sample_cnt_q, bool adjust_delayed_q) {
        // Reset if rstn_i is 0
        if(!rstn_i){
            resetRegisters();
        }
        else{
            switch (state_q){
                case STATE_TX_EOP_STUFF:
                {
                    if(sample_w){
                        NRZI_Receiver();
                    }
                    rx_ready_q = 0;
                    tx_ready_q = 0;
                    errorDetection();
                    checkAdjust();
                    transmitLogic(sample_w);
                    break;
                }
                case STATE_TX_EOP0: {
                    // 1. Rx Error Detection: Rx bit stuffing error
                    if(ones_count_q == 7 || (in_invalid_w && sample_w)) {
                        rx_error_q = true;
                    } else {
                        rx_error_q = false;
                    }
                    // 2. Sample Timer: Delayed adjustment
                    if(adjust_delayed_q) {
                        adjust_delayed_q = false;
                    } else {
                        if(sample_cnt_q == SAMPLE_RATE) {
                            sample_cnt_q = 0;
                        } else {
                            sample_cnt_q = sample_cnt_q + 1;
                        }
                    }
                    // 3. NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
                    if (sample_w) {
                        rxd_last_j_q = in_j_w;
                    }

                    // 4. Set rx_ready_q and tx_ready_q to 1'b0
                    rx_ready_q = false;
                    tx_ready_q = false;

                    // 5. Set send_eop_q to 1'b0
                    send_eop_q = false;

                    // 6. Do Tx: if sample_w then transfer SE0
                    if (sample_w) {
                        out_dp_q = false;
                        out_dn_q = false;
                    }
                    break;
                }
                case STATE_TX_EOP1: {

                    // Rx Error Detection: if ones_count_q == 3'd7 or in_invalid_w && sample_w, the rx_error_q will be set to 1'b1, else set to 1'b0.
                    if(ones_count_q == 7 || (in_invalid_w && sample_w)) {
                        rx_error_q = true;
                    } else {
                        rx_error_q = false;
                    }

                    // Sample Timer:
                    // 1. if adjust_delayed_q then it will be set to 1'b0
                    // 2. else begin
                    //    if sample_cnt_q is equal to SAMPLE_RATE then sample_cnt_q will be set to 3'b0
                    //    else will be set to itself increase one
                    //    end
                    if(adjust_delayed_q) {
                        adjust_delayed_q = false;
                    } else {
                        if(sample_cnt_q == SAMPLE_RATE) {
                            sample_cnt_q = (0);
                        } else {
                            sample_cnt_q = sample_cnt_q + 1;
                        }
                    }

                    // NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
                    if (sample_w) {
                        rxd_last_j_q = in_j_w;
                    }

                    // Set rx_ready_q and tx_ready_q to 1'b0
                    rx_ready_q = false;
                    tx_ready_q = false;

                    // Do Tx: if sample_w then transfer SE0
                    if (sample_w) {
                        out_dp_q = false;
                        out_dn_q = false;
                    }
                    break;
                }
                case STATE_TX_EOP2:
                {
                    // The action code is the same as STATE_TX_EOP0
                    rx_error_q = ((ones_count_q == 7) || (in_invalid_w && sample_w)) ? true : false;
                    if (adjust_delayed_q) {
                        adjust_delayed_q = false;
                    } else {
                        sample_cnt_q = (sample_cnt_q == SAMPLE_RATE) ? 0 : (sample_cnt_q + 1);
                    }
                    if (sample_w) {
                        rxd_last_j_q = in_j_w;
                    }
                    rx_ready_q = false;
                    tx_ready_q = false;

                    // If sample_w is high
                    if (sample_w) {
                        // Transmit SE0, set out_dp_q and out_dn_q
                        out_dp_q = true;
                        out_dn_q = true;

                        // Assign the out_dp to 1'b1 and out_dn to 1'b0, represent idle
                        out_dp_q = true;
                        out_dn_q = false;

                        // Set rx_en_q to 1'b1 indicating the bus is free
                        rx_en_q = true;
                    }
                    break;
                }
                case STATE_TX_RST:
                {
                    // The action code copies the action part of STATE_TX_EOP0
                    rx_error_q = ((ones_count_q == 7) || (in_invalid_w && sample_w)) ? true : false;
                    if (adjust_delayed_q) {
                        adjust_delayed_q = false;
                    } else {
                        sample_cnt_q = (sample_cnt_q == SAMPLE_RATE) ? 0 : (sample_cnt_q + 1);
                    }
                    if (sample_w) {
                        rxd_last_j_q = in_j_w;
                    }
                    rx_ready_q = false;
                    tx_ready_q = false;

                    // Output the SE0 - don't care about sample_w
                    out_dp_q = true;
                    out_dn_q = true;
                    break;
                }
                case STATE_TX_SYNC:
                {
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
                case STATE_TX_ACTIVE:
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
                        (!(data_q & 1) or bit_stuff_bit_w) ? ones_count_q = 0 : ones_count_q++;
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
                    if(!(data_q & 1) or bit_stuff_bit_w) {
                        out_dp_q = !out_dp_q;
                        out_dn_q = !out_dn_q;
                    }
                }
                case STATE_RX_EOP0:
                {
                    // 1. Rx Error Detection: Rx bit stuffing error
                    rx_error_q = (ones_count_q == 7 || in_invalid_w && sample_w) ? true : false;

                    // 2. Sample Timer: Delayed adjustment
                    if (adjust_delayed_q)
                        adjust_delayed_q = false;
                    else if (bit_edge_w && (sample_cnt_q != 0))
                        sample_cnt_q = 0;
                    else if (bit_edge_w && (sample_cnt_q == 0)) {
                        adjust_delayed_q = true;
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    } else {
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    }

                    // 3. NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
                    if (sample_w)
                        rxd_last_j_q = in_j_w;

                    // 4. Set rx_ready_q to 0 and tx_ready_q to 0
                    rx_ready_q = false;
                    tx_ready_q = false;
                }
                case STATE_RX_EOP1:
                {
                    // 1. Rx Error Detection: Rx bit stuffing error
                    rx_error_q = (ones_count_q == 7 || in_invalid_w && sample_w) ? true : false;

                    // 2. Sample Timer: Delayed adjustment
                    if (adjust_delayed_q)
                        adjust_delayed_q = false;
                    else if (bit_edge_w && (sample_cnt_q != 0))
                        sample_cnt_q = 0;
                    else if (bit_edge_w && (sample_cnt_q == 0)) {
                        adjust_delayed_q = true;
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    } else {
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    }

                    // 3. NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
                    if (sample_w)
                        rxd_last_j_q = in_j_w;

                    // 4. Set rx_ready_q to 0 and tx_ready_q to 0
                    rx_ready_q = false;
                    tx_ready_q = false;
                }
                case STATE_RX_DETECT:
                {
                    // 1. Rx Error Detection: Rx bit stuffing error
                    rx_error_q = (ones_count_q == 7 || in_invalid_w && sample_w) ? true : false;

                    // 2. Sample Timer: Delayed adjustment
                    if (adjust_delayed_q)
                        adjust_delayed_q = false;
                    else if (bit_edge_w && (sample_cnt_q != 0))
                        sample_cnt_q = 0;
                    else if (bit_edge_w && (sample_cnt_q == 0)) {
                        adjust_delayed_q = true;
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    } else {
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    }

                    // 3. NRZI Receiver: if sample_w, set rxd_last_j_q as in_j_w
                    if (sample_w)
                        rxd_last_j_q = in_j_w;

                    // 4. Set rx_ready_q to 0 and tx_ready_q to 0
                    rx_ready_q = false;
                    tx_ready_q = false;
                }
                case STATE_RX_SYNC_J:  {
                    // existing actions same as STATE_RX_EOP0
                    rx_error_q = (ones_count_q == 7 || in_invalid_w && sample_w) ? true : false;
                    if (adjust_delayed_q)
                        adjust_delayed_q = false;
                    else if (bit_edge_w && (sample_cnt_q != 0))
                        sample_cnt_q = 0;
                    else if (bit_edge_w && (sample_cnt_q == 0)) {
                        adjust_delayed_q = true;
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    } else {
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    }
                    if (sample_w)
                        rxd_last_j_q = in_j_w;
                    rx_ready_q = false;
                    tx_ready_q = false;

                    // new actions for STATE_RX_SYNC_J
                    sync_j_detected_q = 1;
                    if (sample_w) {
                        bit_count_q = bit_count_q + 1;
                    }
                    break;
                }
                case STATE_RX_SYNC_K:  {
                    bit_count_q = 0;
                    // existing actions same as STATE_RX_EOP0
                    if (!sync_j_detected_q && in_k_w && sample_w)
                        rx_error_q = 1;
                    else
                        rx_error_q = (ones_count_q == 7 || in_invalid_w && sample_w) ? true : false;
                    if (adjust_delayed_q)
                        adjust_delayed_q = false;
                    else if (bit_edge_w && (sample_cnt_q != 0))
                        sample_cnt_q = 0;
                    else if (bit_edge_w && (sample_cnt_q == 0)) {
                        adjust_delayed_q = true;
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    } else {
                        sample_cnt_q = sample_cnt_q == SAMPLE_RATE ? 0 : sample_cnt_q + 1;
                    }
                    if (sample_w)
                        rxd_last_j_q = in_j_w;
                    rx_ready_q = false;
                    tx_ready_q = false;

                    break;
                }
                case STATE_RX_ACTIVE:
                {
                    // rx error detection
                    rx_error_q = ((ones_count_q == 7) || (in_invalid_w && sample_w));

                    // Sample Timer
                    if (adjust_delayed_q) {
                        adjust_delayed_q = false;
                    } else if (bit_edge_w && sample_cnt_q != 0) {
                        sample_cnt_q = 0;
                    } else if (bit_edge_w && sample_cnt_q == 0) {
                        adjust_delayed_q = true;
                        if (sample_cnt_q == SAMPLE_RATE) {
                            sample_cnt_q = 0;
                        } else {
                            sample_cnt_q++;
                        }
                    } else {
                        if (sample_cnt_q == SAMPLE_RATE) {
                            sample_cnt_q = 0;
                        } else {
                            sample_cnt_q++;
                        }
                    }

                    // NRZI Receiver
                    if (sample_w) {
                        rxd_last_j_q = in_j_w;
                    }

                    // Bit counters
                    if (sample_w && !bit_stuff_bit_w) {
                        bit_count_q++;
                    }

                    // Bit counters rx
                    if (sample_w) {
                        ones_count_q = bit_transition_w ? 0 : ones_count_q+1;
                    }

                    // Shift registers
                    if (sample_w && !bit_stuff_bit_w) {
                        data_q = ~(bit_transition_w) << 7 | (data_q >> 1);
                    }

                    // rx_ready condition
                    rx_ready_q = (sample_w && bit_count_q == 7 && !bit_stuff_bit_w) ? true : false;

                    // tx_ready
                    tx_ready_q = false;
                }
                case STATE_IDLE:
                {
                    sync_j_detected_q = false;
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
                    data_q = 0b00101010;

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


            }
        }
    }

    void errorDetection(){
        if(ones_count_q == 7 || (in_invalid_w && sample_w)){
            rx_error_q = 1;
        }else{
            rx_error_q = 0;
        }
    }

    void checkAdjust(){
        if(adjust_delayed_q){
          adjust_delayed_q = 0;
        }else{
            if(sample_cnt_q == SAMPLE_RATE){
              sample_cnt_q = 0;
            }else{
                sample_cnt_q++;
            }
        }
    }

    void transmitLogic(bool sample_w){
        if(sample_w){
            if (!data_q & 1 || bit_stuff_bit_w){ // Data_q[0] equivalent in C++ would be data_q & 1
                out_dp_q = !out_dp_q;
                out_dn_q = !out_dn_q;
            }
        }
    }

    void NRZI_Receiver() {
        rxd_last_j_q = in_j_w;
    }
    void resetRegisters() {
        sync_j_detected_q = 0;
        rx_error_q = 0;
        sample_cnt_q = 0;
        adjust_delayed_q = 0;
        rxd_last_j_q   = 0;
        ones_count_q = 1;
        bit_count_q = 0;
        data_q  = 0;
        rx_ready_q = 0;
        tx_ready_q = 0;
        send_eop_q  = 0;
        out_dp_q = 0;
        out_dn_q = 0;
        rx_en_q  = 1;
    }
    void assignValues() {

        // assignment statements
        utmi_rxerror_o = rx_error_q;
        bit_edge_w = rxd_last_q ^ sample_w;
        sample_w = (sample_cnt_q == 0);
        bit_transition_w = sample_w ? rxd_last_q ^ sample_w : 0;
        bit_stuff_bit_w = (ones_count_q == 6);
        next_is_bit_stuff_w = (ones_count_q == 5) && !bit_transition_w;
        utmi_rxactive_o = (state_q == (STATE_RX_ACTIVE));
        utmi_data_in_o = data_q;
        utmi_rxvalid_o = rx_ready_q;
        utmi_txready_o = rx_ready_q;
        usb_reset_detect_o = (se0_cnt_q == 127);
        usb_tx_oen_o = rx_ready_q;
        usb_tx_dp_o = rx_ready_q;
        usb_tx_dn_o = rx_ready_q;
        utmi_linestate_o = usb_tx_oen_o ? rx_ready_q : usb_tx_dp_o;
        usb_en_o = utmi_termselect_i;

        // additional variables
        in_dp_w = usb_rx_dp_i;
        in_dn_w = usb_rx_dn_i;
        in_rx_w = usb_rx_rcv_i;
        in_j_w = in_rx_w ? (0) : rxd_q;
        in_k_w = in_rx_w ? (0) : ~rxd_q;
        in_se0_w = (!in_dp_w & !in_dn_w);
        in_invalid_w = (in_dp_w & in_dn_w);
    }


    // TO-DO: Add necessary methods for the operational logic.
};
