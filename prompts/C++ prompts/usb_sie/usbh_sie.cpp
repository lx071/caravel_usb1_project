#include <bitset>
using namespace std;

// Setting the USB frequency
const int USB_CLK_FREQ = 60000000;

// States of state machine
#define STATE_IDLE 0;
#define STATE_RX_DATA 1;
#define STATE_TX_PID 2;
#define STATE_TX_DATA 3;
#define STATE_TX_CRC1 4;
#define STATE_TX_CRC2 5;
#define STATE_TX_TOKEN1 6;
#define STATE_TX_TOKEN2 7;
#define STATE_TX_TOKEN3 8;
#define STATE_TX_ACKNAK 9;
#define STATE_TX_WAIT 10;
#define STATE_RX_WAIT 11;
#define STATE_TX_IFS 12;

// Creating module usbh_sie
class usbh_sie {
public:
    // Inputs
    bool clk_i, rstn_i, start_i, in_transfer_i, sof_transfer_i, resp_expected_i, utmi_txready_i, utmi_rxvalid_i, utmi_rxactive_i;
    int token_pid_i, tx_data_i, utmi_data_i;
    int token_dev_i;
    int token_ep_i;
    int data_len_i;
    bool data_idx_i;
    int utmi_linestate_i;

    // Outputs
    bool ack_o, tx_pop_o, rx_push_o, tx_done_o, rx_done_o, crc_err_o, timeout_o, idle_o, utmi_txvalid_o;
    int rx_data_o, response_o, utmi_data_o;
    int rx_count_o;

    // Registers
    bool start_ack_q, status_tx_done_q, status_rx_done_q, status_crc_err_q, status_timeout_q, in_transfer_q, send_data1_q, send_sof_q, send_ack_q, wait_resp_q;
    int status_response_q, last_tx_time_q;
    int byte_count_q, crc_sum_q, token_q;
    int state_q;

    // Wires
    int crc_out_w;
    int crc_data_in_w;
    int crc5_out_w, crc5_next_w = crc5_out_w ^ 0x1F; // XOR operation

    // Local parameters
    int RX_TIMEOUT = (USB_CLK_FREQ == 60000000) ? 511 : 255;
    int TX_IFS = (USB_CLK_FREQ == 60000000) ? 10 : 7;
    int PID_OUT = 0xE1, PID_IN = 0x69, PID_SOF = 0xA5, PID_SETUP = 0x2D, PID_DATA0 = 0xC3, PID_DATA1 = 0x4B, PID_ACK = 0xD2, PID_NAK = 0x5A, PID_STALL = 0x1E;

    enum DataType {
        SOF,
        IN,
        OUT_SETUP,
    };

    // Additional registers
    int utmi_linestate_q, data_crc_q;
    bool se0_detect_q, wait_eop_q;
    int data_buffer_q;
    int data_valid_q, rx_active_q, next_state_q;

    // Constants
    static constexpr int TX_IFS_W = 4;
    
    // Registers
    bitset<TX_IFS_W> tx_ifs_q;

    // Wires for Rx data
    int rx_data_w;
    bool data_ready_w, crc_byte_w, rx_active_w, rx_active_rise_w;

    // Wires for Tx/Rx IFS timeout and response timeout
    bool ifs_busy_w;
    bool rx_resp_timeout_w = (last_tx_time_q >= RX_TIMEOUT) && wait_resp_q;

    // Wire for SE0 detect and EOP detect status
    bool se0_detect_w = (utmi_linestate_i == 0) && (utmi_linestate_q == 0);
    bool eop_detected_w = se0_detect_q && (utmi_linestate_i != 0);

    // Wire for enabling shift
    bool shift_en_w = (utmi_rxvalid_i && utmi_rxactive_i) || !utmi_rxactive_i;

    // Wire for recording CRC16 error
    bool crc_error_w = (state_q == 1) && !rx_active_w && in_transfer_q && (status_response_q == PID_DATA0 || status_response_q == PID_DATA1) && (crc_sum_q != 0xB001);

    void Assign_State(){
                // Determine the data type
        DataType data_Type;
        if (send_sof_q) data_Type = DataType::SOF;
        else if (in_transfer_q) data_Type = DataType::IN;
        else data_Type = DataType::OUT_SETUP;

        // Current _q state becomes the next _q state
        next_state_q = state_q;

        int temp = next_state_q;

        // Define the next state based on the current state and variables
        switch (temp) {
            case 6: 
            {
                if (utmi_txready_i) next_state_q = STATE_TX_TOKEN2;
                break;
            }

            case 7:
                if (utmi_txready_i) next_state_q = STATE_TX_TOKEN3;
                break;

            case 8:
                if (utmi_txready_i) next_state_q = data_Type == DataType::SOF ? 12 : (data_Type == DataType::IN ? 11 : 12);
                break;

            case 12:
                if (!ifs_busy_w) next_state_q = data_Type == DataType::SOF ? 0 : 2;
                break;

            case 2:
                if (utmi_txready_i && byte_count_q == 0) {
                    next_state_q = STATE_TX_CRC1;
                } 
                else if (utmi_txready_i && byte_count_q > 0) {
                    next_state_q = STATE_TX_DATA;
                }
                break;

            case 3:
                if (utmi_txready_i && byte_count_q == 0) next_state_q = STATE_TX_CRC1;
                break;

            case 4:
                if (utmi_txready_i) next_state_q = STATE_TX_CRC2;
                break;

            case 5:
                if (utmi_txready_i) next_state_q =  wait_resp_q ? 11 : 0;
                break;

            case 10:
                if (!ifs_busy_w) next_state_q = STATE_TX_ACKNAK;
                break;

            case 9:
                if (utmi_txready_i) next_state_q = STATE_IDLE;
                break;

            case 11:
                if (data_ready_w) {next_state_q = STATE_RX_DATA;}
                else if (rx_resp_timeout_w) next_state_q = STATE_IDLE;
                break;

            case 1:
                if (!rx_active_w) {
                    if ((send_ack_q && crc_error_w) || (send_ack_q && (response_o == PID_DATA0 || response_o == PID_DATA1))) 
                    {next_state_q = STATE_TX_WAIT;}
                    else next_state_q = STATE_IDLE;
                }
                break;

            case 0:
                if (start_i) next_state_q = STATE_TX_TOKEN1;
                break;

            default:
                break; 
        }
    }

    void resetRegisters() {
        start_ack_q = 0;
        status_tx_done_q = 0;
        status_rx_done_q = 0;
        status_crc_err_q = 0;
        status_timeout_q = 0;
        byte_count_q = 0;
        in_transfer_q = 0;
        last_tx_time_q = 0;
        send_data1_q = 0;
        send_sof_q = 0;
        send_ack_q = 0;
        token_q = 0;
        wait_resp_q = 0;
        state_q = 0;
  
        se0_detect_q = false;
        wait_eop_q = false;
        rx_active_q = 0;
        data_buffer_q = 0;
        data_valid_q = 0;
        data_crc_q = 0;
        next_state_q = 0;
        tx_ifs_q = 0;
    }




    // Function triggered by the clock's positive edge or rstn's negative edge
    void onClock(bool posedge_clk, bool negedge_rstn) {
        // On clock's positive edge or rstn's negative edge
        if (posedge_clk || negedge_rstn) {
            // Check if the rstn is inactive
            if (!rstn_i) {
                state_q = STATE_IDLE;
            } else {
                Assign_State();  // Update the state machine before updating the state
                state_q = next_state_q;
            }
        }
    }

        void onClock2(bool posedge_clk, bool negedge_rstn) {
        // On clock's positive edge or rstn's negative edge
        if (posedge_clk || negedge_rstn) {
            // Check if the rstn is inactive...
        }
        int temp = state_q;
        // If clock's positive edge
        if (posedge_clk) {
            switch (temp) {
                case 0:  // If the state is IDLE
                    // Update token register
                    token_q = (token_dev_i << 4) | token_ep_i;

                    // Reset some registers
                    last_tx_time_q = 0;
                    start_ack_q = 0;
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    
                    // End of detection
                    if (eop_detected_w)
                        wait_eop_q = 0;
                    else if (rx_active_rise_w)
                        wait_eop_q = 1;

                    if (start_i) {
                        // if the start input is set
                        in_transfer_q = in_transfer_i;
                        send_ack_q = in_transfer_i && resp_expected_i;
                        send_data1_q = data_idx_i;
                        send_sof_q = sof_transfer_i;
                        wait_resp_q = resp_expected_i;

                        // Check sof_transfer_i
                        if (!sof_transfer_i) {
                            byte_count_q = data_len_i;
                            status_response_q = 0;
                            status_timeout_q = 0;
                            status_crc_err_q = 0;
                        }
                    }
                    break;

                // ... other states ...
                case 6:  
                    // If the state is TX_TOKEN1
                    // Reset status_rx_done_q & status_tx_done_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    
                    // End of detection
                    if (eop_detected_w)
                        wait_eop_q = 0;
                    else if (rx_active_rise_w)
                        wait_eop_q = 1;
                    
                    // Check utmi_txready_i
                    if (utmi_txready_i) {
                        start_ack_q = 1;
                        bitset<16Ui64> temp1 = 0xFFF0;
                        token_q = (token_q & temp) | crc5_next_w;
                        // Reset last_tx_time_q if utmi_txvalid_o is 1
                        if (utmi_txvalid_o == 1)
                            last_tx_time_q = 0;
                    } else {
                        start_ack_q = 0;
                        // Increase last_tx_time_q if it's not equal to RX_TIMEOUT
                        if (last_tx_time_q != RX_TIMEOUT)
                            last_tx_time_q=+1;
                    }
                    break;

                case 7:
                    // If the state is TX_TOKEN2
                    // Reset status_rx_done_q, status_tx_done_q and start_ack_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;

                    // End of detection
                    if (eop_detected_w)
                        wait_eop_q = 0;
                    else if (rx_active_rise_w)
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o 
                    if (utmi_txready_i && utmi_txvalid_o)
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT)
                        last_tx_time_q++;

                    break;


                case 8:
                    // If the state is STATE_TX_TOKEN3
                    // Reset status_rx_done_q, status_tx_done_q and start_ack_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;
                    
                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w || next_state_q != 8) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;

                    break;


                case 12:
                    // If the state is STATE_TX_IFS
                    // Reset status_rx_done_q, status_tx_done_q and start_ack_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;
                    
                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;

                    break;

                case 2:
                     // If the state is STATE_TX_PID
                     // Reset status_rx_done_q, status_tx_done_q, start_ack_q and crc_sum_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;
                    crc_sum_q = 0xFFFF;

                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;

                    // Decrease byte_count_q if utmi_txready_i and byte_count_q is not zero
                    if (utmi_txready_i && byte_count_q != 0)
                        byte_count_q--;    
                    break;


                case 3:
                    // If the state is STATE_TX_DATA
                    // Reset status_rx_done_q, status_tx_done_q and start_ack_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;
                    
                    // If utmi_txready_i is set, crc_sum_q is assigned by crc_out_w
                    if (utmi_txready_i) 
                        crc_sum_q = crc_out_w;

                    // End of detection
                    if (eop_detected_w)
                        wait_eop_q = 0;
                    else if (rx_active_rise_w) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o)
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT)
                        last_tx_time_q++;

                    // Decrease byte_count_q if utmi_txready_i and byte_count_q is not zero
                    if (utmi_txready_i && byte_count_q != 0)
                        byte_count_q--;
                    
                    break;     

                case 4:
                     // If the state is STATE_TX_CRC1
                     // Reset status_rx_done_q, status_tx_done_q and start_ack_q
                        status_rx_done_q = 0;
                        status_tx_done_q = 0;
                         start_ack_q = 0;

                  // End of detection
                  if (eop_detected_w) 
                        wait_eop_q = 0;
                  else if (rx_active_rise_w)
                         wait_eop_q = 1;

                     // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                          last_tx_time_q = 0;
                   else if (last_tx_time_q != RX_TIMEOUT) 
                         last_tx_time_q++;
    
                   break;   

                case 5:
                    // If the state is STATE_TX_CRC2
                    // Reset status_rx_done_q, status_tx_done_q, start_ack_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;

                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w || next_state_q != 5) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;

                    // If utmi_txready_i is set and wait_resp_q is unset, set status_tx_done_q
                    if (utmi_txready_i && !wait_resp_q)
                        status_tx_done_q = 1;
                    
                    break;

                case 10:
                    // If the state is STATE_TX_WAIT
                    // Reset status_rx_done_q, status_tx_done_q and start_ack_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;

                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;
                    
                    break;

                case 9:
                    // If the state is STATE_TX_ACKNAK
                    // Reset status_rx_done_q, status_tx_done_q and start_ack_q
                    status_rx_done_q = 0;
                    status_tx_done_q = 0;
                    start_ack_q = 0;

                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w || next_state_q != 9) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;

                    break;

                case 11:
                    // If the state is STATE_RX_WAIT
                    // Reset status_tx_done_q, start_ack_q, byte_count_q and crc_sum_q
                    status_tx_done_q = 0;
                    start_ack_q = 0;
                    byte_count_q = 0;
                    crc_sum_q = 0xFFFF;

                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;

                    // If data_ready_w is set, assign status_response_q by rx_data_w and reset wait_resp_q
                    if (data_ready_w) {
                        status_response_q = rx_data_w;
                        wait_resp_q = 0;
                    }

                    // If rx_resp_timeout_w is set, set status_timeout_q
                    if (rx_resp_timeout_w)
                        status_timeout_q = 1;
                    
                    break;

                case 1:
                    // If the state is STATE_RX_DATA
                    // Rest start_ack_q
                    start_ack_q = 0;

                    // End of detection
                    if (eop_detected_w) 
                        wait_eop_q = 0;
                    else if (rx_active_rise_w) 
                        wait_eop_q = 1;

                    // Check utmi_txready_i and utmi_txvalid_o
                    if (utmi_txready_i && utmi_txvalid_o) 
                        last_tx_time_q = 0;
                    else if (last_tx_time_q != RX_TIMEOUT) 
                        last_tx_time_q++;

                    // If utmi_rxactive_i is set, reset status_rx_done_q else set status_rx_done_q
                    status_rx_done_q = utmi_rxactive_i ? 0 : 1;

                    // If data_ready_w is set AND crc_byte_w is unset, increase byte_count_q
                    if (data_ready_w && !crc_byte_w)
                        byte_count_q++;

                    // If data_ready_w is set
                    if (data_ready_w)
                        crc_sum_q = crc_out_w;
                    else if (!rx_active_w)
                        status_crc_err_q = crc_error_w ? 1 : 0;
                    
                    break;


                default:
                    break;
            }
        }
    }

    bool utmi_txvalid_r;
    int utmi_data_r;
    int token_rev_w;

    void simulate() {
        // Assignments
        ifs_busy_w = wait_eop_q || (tx_ifs_q != ((1 << TX_IFS_W) - 1));
        rx_data_w = data_buffer_q & 0xFF;
        data_ready_w = data_valid_q & 0x1;
        crc_byte_w = data_crc_q & 0x1;
        rx_active_w = rx_active_q & 0x1;
        rx_active_rise_w = !((rx_active_q >> 3) & 0x1) && utmi_rxactive_i;

        // TODO: Add your remaining logic here

                // Loop to handle the token
        for (int i = 0; i < 16; i++) {
            // Assign the 15-i th bit of token_q to the i th bit of token_rev_w
            token_rev_w = token_q>>(15-i) & 1;
        }

        // Continuous assignment block
        if (state_q == 4) {
            utmi_txvalid_r = true;
            utmi_data_r = crc_sum_q & 0xFF;
        } else if (state_q == 5) {
            utmi_txvalid_r = true;
            utmi_data_r = (crc_sum_q >> 8) & 0xFF;
        } else if (state_q == 6) {
            utmi_txvalid_r = true;
            utmi_data_r = token_pid_i;
        } else if (state_q == 7) {
            utmi_txvalid_r = true;
            utmi_data_r = token_rev_w & 0xFF;
        } else if (state_q == 8) {
            utmi_txvalid_r = true;
            utmi_data_r = (token_rev_w >> 8) & 0xFF;
        } else if (state_q == 2) {
            utmi_txvalid_r = true;
            if (send_data1_q) {
                utmi_data_r = PID_DATA1;
            } else {
                utmi_data_r = PID_DATA0;
            }
        } else if (state_q == 9) {
            utmi_txvalid_r = true;
            utmi_data_r = PID_ACK;
        } else if (state_q == 3) {
            utmi_txvalid_r = true;
            utmi_data_r = tx_data_i;
        } else {
            utmi_txvalid_r = false;
            utmi_data_r = 0;
        }

        // (1) Assign utmi_txvalid_o
        utmi_txvalid_o = utmi_txvalid_r;

        // (2) Assign utmi_data_o
        utmi_data_o = utmi_data_r;

        // (3) Assign rx_data_o
        rx_data_o = rx_data_w;

        // (4) Assign rx_push_o
        rx_push_o = data_ready_w && !crc_byte_w && (state_q != 0 && state_q != 11);

        // (5) Assign crc_data_in_w
        crc_data_in_w = (state_q == 1) ? rx_data_w : tx_data_i;

        // (6) Assign rx_count_o
        rx_count_o = byte_count_q;

        // (7) Assign idle_o
        idle_o = (state_q == 0);

        // (8) Assign ack_o
        ack_o = start_ack_q;

        // (9) Assign tx_pop_o
        tx_pop_o = (state_q == 3) && utmi_txready_i;

        // (10) Assign tx_done_o
        tx_done_o = status_tx_done_q;

        // (11) Assign rx_done_o
        rx_done_o = status_rx_done_q;

        // (12) Assign crc_err_o
        crc_err_o = status_crc_err_q;

        // (13) Assign timeout_o
        timeout_o = status_timeout_q;

        // (14) Assign response_o
        response_o = status_response_q;
    }
};

class usbh_crc16 {
public:
    // Inputs
    uint16_t crc_i;
    uint8_t data_i;

    // Outputs
    uint16_t crc_o;

    // Constructor
    usbh_crc16() {
        // Initialize inputs
        crc_i = 0;
        data_i = 0;

        // Initialize outputs
        crc_o = 0;
    }

    // Method to calculate CRC16
    void calculate() {
        // TODO: Add your CRC16 calculation logic here
        // You can use the crc_i and data_i variables to perform the calculation
        // and assign the result to the crc_o variable
    }
};

class usbh_crc5 {
public:
    // Inputs
    uint8_t crc_i;
    uint16_t data_i;

    // Outputs
    uint8_t crc_o;

    // Constructor
    usbh_crc5() {
        // Initialize inputs
        crc_i = 0;
        data_i = 0;

        // Initialize outputs
        crc_o = 0;
    }

    // Method to calculate CRC5
    void calculate() {
        // TODO: Add your CRC5 calculation logic here
        // You can use the crc_i and data_i variables to perform the calculation
        // and assign the result to the crc_o variable
    }
};