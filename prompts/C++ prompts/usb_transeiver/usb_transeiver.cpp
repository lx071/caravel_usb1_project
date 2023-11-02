#include <iostream>

class USBTransceiver {
private:
    bool in_dp;
    bool in_dn;
    bool out_dp;
    bool out_dn;
    bool out_tx_oen;
    bool usb_phy_tx_dp_i;
    bool usb_phy_tx_dn_i;
    bool usb_phy_tx_oen_i;
    bool mode_i;
    bool usb_phy_rx_rcv_o;
    bool usb_phy_rx_dp_o;
    bool usb_phy_rx_dn_o;

public:
    USBTransceiver() {
        // Initialize all signals to default values
        in_dp = false;
        in_dn = false;
        out_dp = false;
        out_dn = false;
        out_tx_oen = false;
        usb_phy_tx_dp_i = false;
        usb_phy_tx_dn_i = false;
        usb_phy_tx_oen_i = false;
        mode_i = false;
        usb_phy_rx_rcv_o = false;
        usb_phy_rx_dp_o = false;
        usb_phy_rx_dn_o = false;
    }

    void update() {
        // Update the output signals based on the input signals and mode
        if (mode_i == false) {
            if (usb_phy_tx_dp_i == false && usb_phy_tx_dn_i == false) {
                out_dp = false;
                out_dn = true;
            } else if (usb_phy_tx_dp_i == false && usb_phy_tx_dn_i == true) {
                out_dp = false;
                out_dn = false;
            } else if (usb_phy_tx_dp_i == true && usb_phy_tx_dn_i == false) {
                out_dp = true;
                out_dn = false;
            } else if (usb_phy_tx_dp_i == true && usb_phy_tx_dn_i == true) {
                out_dp = false;
                out_dn = false;
            }
        } else {
            if (usb_phy_tx_dp_i == false && usb_phy_tx_dn_i == false) {
                out_dp = false;
                out_dn = false;
            } else if (usb_phy_tx_dp_i == false && usb_phy_tx_dn_i == true) {
                out_dp = false;
                out_dn = true;
            } else if (usb_phy_tx_dp_i == true && usb_phy_tx_dn_i == false) {
                out_dp = true;
                out_dn = false;
            } else if (usb_phy_tx_dp_i == true && usb_phy_tx_dn_i == true) {
                out_dp = true;
                out_dn = true;
            }
        }

        // Update usb_phy_rx_rcv_o based on in_dp and in_dn
        if (in_dp == true && in_dn == false) {
            usb_phy_rx_rcv_o = true;
        } else {
            usb_phy_rx_rcv_o = false;
        }

        // Update usb_phy_rx_dp_o and usb_phy_rx_dn_o based on out_dp and out_dn
        usb_phy_rx_dp_o = out_dp;
        usb_phy_rx_dn_o = out_dn;

        // Update out_tx_oen based on usb_phy_tx_oen_i
        out_tx_oen = usb_phy_tx_oen_i;
    }

    // Setters for input signals
    void setInDp(bool value) {
        in_dp = value;
    }

    void setInDn(bool value) {
        in_dn = value;
    }

    void setUsbPhyTxDpI(bool value) {
        usb_phy_tx_dp_i = value;
    }

    void setUsbPhyTxDnI(bool value) {
        usb_phy_tx_dn_i = value;
    }

    void setUsbPhyTxOenI(bool value) {
        usb_phy_tx_oen_i = value;
    }

    void setModeI(bool value) {
        mode_i = value;
    }

    // Getters for output signals
    bool getOutDp() {
        return out_dp;
    }

    bool getOutDn() {
        return out_dn;
    }

    bool getOutTxOen() {
        return out_tx_oen;
    }

    bool getUsbPhyRxRcvO() {
        return usb_phy_rx_rcv_o;
    }

    bool getUsbPhyRxDpO() {
        return usb_phy_rx_dp_o;
    }

    bool getUsbPhyRxDnO() {
        return usb_phy_rx_dn_o;
    }
};

int main() {
    // Create an instance of the USBTransceiver module
    USBTransceiver usbTransceiver;

    // Set the input signals
    usbTransceiver.setInDp(true);
    usbTransceiver.setInDn(false);
    usbTransceiver.setUsbPhyTxDpI(true);
    usbTransceiver.setUsbPhyTxDnI(false);
    usbTransceiver.setUsbPhyTxOenI(true);
    usbTransceiver.setModeI(false);

    // Update the module
    usbTransceiver.update();

    // Get the output signals
    bool out_dp = usbTransceiver.getOutDp();
    bool out_dn = usbTransceiver.getOutDn();
    bool out_tx_oen = usbTransceiver.getOutTxOen();
    bool usb_phy_rx_rcv_o = usbTransceiver.getUsbPhyRxRcvO();
    bool usb_phy_rx_dp_o = usbTransceiver.getUsbPhyRxDpO();
    bool usb_phy_rx_dn_o = usbTransceiver.getUsbPhyRxDnO();

    // Print the output signals
    std::cout << "out_dp: " << out_dp << std::endl;
    std::cout << "out_dn: " << out_dn << std::endl;
    std::cout << "out_tx_oen: " << out_tx_oen << std::endl;
    std::cout << "usb_phy_rx_rcv_o: " << usb_phy_rx_rcv_o << std::endl;
    std::cout << "usb_phy_rx_dp_o: " << usb_phy_rx_dp_o << std::endl;
    std::cout << "usb_phy_rx_dn_o: " << usb_phy_rx_dn_o << std::endl;

    return 0;
}