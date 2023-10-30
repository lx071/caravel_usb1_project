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
                                                              
                   AES Key Expand Block (for 128 bit keys)
                                                              
  Description                                                 
     AES Top module includes 128 bit aes_key_expand_128
     
  To Do:                                                      
    1. Integration 192/256 AES
                                                              
  Author(s):                                                  
      - Rudolf Usselmann ,rudi@asics.ws                        
      - Dinesh Annayya, dinesh.annayya@gmail.com                 
                                                              
  Revision :                                                  
     0.0  - Oct 15, 2022 
            Initial Version picked from https://opencores.org/ocsvn/aes_core                                    
     0.1  - Nov 3, 2022
            Following changes are done
            1. To reduce the design area 
               A. 4 cycle for next round key computation
           
                                                              
************************************************************************************/
/************************************************************************************
                      Copyright (C) 2000-2002 
              Rudolf Usselmann,www.asics.ws <rudi@asics.ws>
              Dinesh Annayya <dinesh.annayya@gmail.com>
                                                             
       This source file may be used and distributed without        
       restriction provided that this copyright statement is not   
       removed from the file and that any derivative work contains 
       the original copyright notice and the associated disclaimer.
                                                                   
           THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     
       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   
       TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   
       FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      
       OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         
       INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    
       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   
       GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        
       BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  
       LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  
       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  
       OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         
       POSSIBILITY OF SUCH DAMAGE.                                 
                                                             
************************************************************************************/


module aes_key_expand_128(
    input  logic         clk, 
    input  logic         rstn, 
    input  logic         kld,
    input  logic         knxt,
    output logic         key_rdy, 
    input  logic [127:0] key, 
    output logic [31:0]  wo_0, 
    output logic [31:0]  wo_1, 
    output logic [31:0]  wo_2, 
    output logic [31:0]  wo_3
   );


reg	  [31:0]	w[3:0];
wire  [31:0]	tmp_w;
wire  [31:0]	subword;
wire  [31:0]	rcon;
reg   [7:0]     sbox_arry[0:3];
reg   [1:0]     scnt;
reg   [7:0]     sbox_in;
reg   [7:0]     sbox_out;
reg             active;
reg             kld_nxt;

assign wo_0 = w[0];
assign wo_1 = w[1];
assign wo_2 = w[2];
assign wo_3 = w[3];
always @(posedge clk)	w[0] <= kld ? key[127:096] : (kld_nxt) ? w[0]^subword^rcon                  : w[0] ;
always @(posedge clk)	w[1] <= kld ? key[095:064] : (kld_nxt) ? w[0]^w[1]^subword^rcon             : w[1] ;
always @(posedge clk)	w[2] <= kld ? key[063:032] : (kld_nxt) ? w[0]^w[2]^w[1]^subword^rcon        : w[2] ;
always @(posedge clk)	w[3] <= kld ? key[031:000] : (kld_nxt) ? w[0]^w[3]^w[2]^w[1]^subword^rcon   : w[3] ;
assign tmp_w = w[3];

always @(posedge clk or negedge rstn)
begin
  if(!rstn) begin
     scnt   <= 'h0;
     active <= 'b0;
     kld_nxt<= 'b0;
     key_rdy<= 'b0;
  end else begin
     if(kld || knxt) begin 
        scnt    <= 'h0; 
        active  <= 'b1;
     end else if(active) begin 
          scnt  <= scnt+1; 
          active <= !(&scnt);
     end
     kld_nxt  <= &scnt; 
     key_rdy  <= kld_nxt | kld ;
    
     sbox_arry[scnt] <=  sbox_out;
  end
end

always_comb
begin
  sbox_in = 0;
  case(scnt)
  'h0:  sbox_in = tmp_w[23:16];
  'h1:  sbox_in = tmp_w[15:08];
  'h2:  sbox_in = tmp_w[07:00];
  'h3:  sbox_in = tmp_w[31:24];
  endcase
end
aes_sbox us(.a(	sbox_in	), .d(	sbox_out	));

assign subword[31:24] = sbox_arry[0];
assign subword[23:16] = sbox_arry[1];
assign subword[15:08] = sbox_arry[2];
assign subword[07:00] = sbox_arry[3];
/**
aes_sbox u0(	.a(tmp_w[23:16]), .d(subword[31:24]));
aes_sbox u1(	.a(tmp_w[15:08]), .d(subword[23:16]));
aes_sbox u2(	.a(tmp_w[07:00]), .d(subword[15:08]));
aes_sbox u3(	.a(tmp_w[31:24]), .d(subword[07:00]));
**/
aes_rcon r0(	.clk(clk), .kld(kld), .knxt (kld_nxt),.out(rcon));
endmodule

