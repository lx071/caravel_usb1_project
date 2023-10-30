/*********************************************************************************
 SPDX-FileCopyrightText: 2021 , Dinesh Annayya                          
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 SPDX-License-Identifier: Apache-2.0
 SPDX-FileContributor: Created by Dinesh Annayya <dinesh.annayya@gmail.com>

***********************************************************************************/
/**********************************************************************************
                                                              
                   AES  Top Module                                             
                                                              
  Description                                                 
     AES Top module includes 128 bit aes_cipher &  aes_inv_cipher                                           
     
  To Do:                                                      
    1. Integration 192/256 AES
                                                              
  Author(s):                                                  
      - Dinesh Annayya, dinesh.annayya@gmail.com                 
                                                              
  Revision :                                                  
     0.0  - Oct 15, 2022 
            Initial Version picked from https://opencores.org/ocsvn/aes_core                                    
     0.1  - Nov 3, 2022
            Following changes are done
            1. Wishbone register interface added
            2. To reduce the design area of the aes_cipher and aes_inv_cipher
               A. aes_sbox used sequentially for 16 cycle for text compuation 
               B. 4 cycle for next round key computation
     0.2 - Nov 7, 2022
           Change the Reg I/F to DMEM interface for better RISCV core integration
           
                                                              
************************************************************************************/
/************************************************************************************
  ECB Mode : ECB mode is the simplest block cipher mode of operation in existence.  
    Its approach to multi-block plaintexts is to treat each block of the plaintext separately.
    encryption/decryption of one block has no effect on the encryption/decryption of any other. 

  CBC Mode : CBC mode eliminates this problem by carrying information from the encryption or 
    decryption of one block to the next.


**************************************************************************************/


module aes_top #( parameter WB_WIDTH = 32) (
`ifdef USE_POWER_PINS
    input logic                          vccd1,    // User area 1 1.8V supply
    input logic                          vssd1,    // User area 1 digital ground
`endif

    input  logic                         mclk,
    input  logic                         rst_n,

    input  logic   [3:0]                 cfg_cska,
    input  logic                         wbd_clk_int,
    output logic                         wbd_clk_out,

    input   logic                        dmem_req,
    input   logic                        dmem_cmd,
    input   logic [1:0]                  dmem_width,
    input   logic [6:0]                  dmem_addr,
    input   logic [31:0]                 dmem_wdata,
    output  logic                        dmem_req_ack,
    output  logic [31:0]                 dmem_rdata,
    output  logic [1:0]                  dmem_resp
);


logic         dmem_req_ack_enc;
logic [31:0]  dmem_rdata_enc;
logic [1:0]   dmem_resp_enc;

logic         dmem_req_ack_decr;
logic [31:0]  dmem_rdata_decr;
logic [1:0]   dmem_resp_decr;


// Encription local variable
logic         cfg_enc_ld      ;                   
logic         enc_done        ;                    
logic [127:0] cfg_enc_key     ;
logic [127:0] cfg_enc_text_in ;
logic [127:0] enc_text_out    ;

// Decryption local variable
logic         cfg_decr_kld    ;                
logic         decr_done       ;                
logic [127:0] cfg_decr_key    ;                
logic [127:0] cfg_decr_text_in;            
logic [127:0] decr_text_out   ;               


assign dmem_req_ack = dmem_req_ack_enc | dmem_req_ack_decr;

assign dmem_rdata =  (dmem_resp_enc == 2'b01) ? dmem_rdata_enc : (dmem_resp_decr == 2'b01) ? dmem_rdata_decr : 'h0;
assign dmem_resp  = ((dmem_resp_enc == 2'b01) || (dmem_resp_decr == 2'b01)) ? 2'b01: 2'b00;

//###################################
// Clock Skey for WB clock
//###################################
clk_skew_adjust u_skew
       (
`ifdef USE_POWER_PINS
           .vccd1      (vccd1                      ),// User area 1 1.8V supply
           .vssd1      (vssd1                      ),// User area 1 digital ground
`endif
	       .clk_in     (wbd_clk_int                ), 
	       .sel        (cfg_cska                   ), 
	       .clk_out    (wbd_clk_out                ) 
       );

//###################################
// Application Reset Synchronization
//###################################
reset_sync  u_app_rst (
	         .scan_mode  (1'b0        ),
             .dclk       (mclk        ), // Destination clock domain
	         .arst_n     (rst_n       ), // active low async reset
             .srst_n     (rst_ss_n    )
          );


//###################################
// Encription Register
//###################################
aes_reg u_enc_reg(
        .mclk                           (mclk                         ),
        .rst_n                          (rst_ss_n                     ),

        .cfg_port_id                    (1'b0                         ),

        .dmem_req                       (dmem_req                     ), 
        .dmem_cmd                       (dmem_cmd                     ), 
        .dmem_width                     (dmem_width                   ), 
        .dmem_addr                      (dmem_addr                    ), 
        .dmem_wdata                     (dmem_wdata                   ), 
        .dmem_req_ack                   (dmem_req_ack_enc             ), 
        .dmem_rdata                     (dmem_rdata_enc               ), 
        .dmem_resp                      (dmem_resp_enc                ), 

      // Encription Reg Interface
        .cfg_aes_ld                     (cfg_enc_ld                   ),
        .aes_done                       (enc_done                     ),
        .cfg_key                        (cfg_enc_key                  ),
        .cfg_text_in                    (cfg_enc_text_in              ),
        .text_out                       (enc_text_out                 )

      );


//###################################
// Encription core
//###################################
aes_cipher_top  u_cipher (
       .clk                             (mclk                        ), 
       .rstn                            (rst_ss_n                    ), 
       .ld                              (cfg_enc_ld                  ), 
       .done                            (enc_done                    ), 
       .key                             (cfg_enc_key                 ), 
       .text_in                         (cfg_enc_text_in             ), 
       .text_out                        (enc_text_out                )
     );

//###################################
// Decryption Register
//###################################
aes_reg u_decr_reg(
        .mclk                           (mclk                         ),
        .rst_n                          (rst_ss_n                     ),

        .cfg_port_id                    (1'b1                         ),

        .dmem_req                       (dmem_req                     ), 
        .dmem_cmd                       (dmem_cmd                     ), 
        .dmem_width                     (dmem_width                   ), 
        .dmem_addr                      (dmem_addr                    ), 
        .dmem_wdata                     (dmem_wdata                   ), 
        .dmem_req_ack                   (dmem_req_ack_decr            ), 
        .dmem_rdata                     (dmem_rdata_decr              ), 
        .dmem_resp                      (dmem_resp_decr               ), 

      // Decription Reg Interface
        .cfg_aes_ld                     (cfg_decr_kld                 ),
        .aes_done                       (decr_done                    ),
        .cfg_key                        (cfg_decr_key                 ),
        .cfg_text_in                    (cfg_decr_text_in             ),
        .text_out                       (decr_text_out                )

      );

//###################################
// Decryption Core
//###################################
aes_inv_cipher_top u_icipher (
       .clk                            (mclk                         ), 
       .rstn                           (rst_ss_n                     ), 
       .kld                            (cfg_decr_kld                 ), 
       .ld                             (decr_kdone                   ), 
       .kdone                          (decr_kdone                   ),
       .done                           (decr_done                    ), 
       .key                            (cfg_decr_key                 ), 
       .text_in                        (cfg_decr_text_in             ), 
       .text_out                       (decr_text_out                ) 
     );

endmodule


