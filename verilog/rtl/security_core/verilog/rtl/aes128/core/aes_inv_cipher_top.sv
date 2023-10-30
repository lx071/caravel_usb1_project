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
                                                              
                   AES Decryption Core Module                                             
                                                              
  Description                                                 
     AES Top module includes aes_inv_cipher 128 bit core                                           
     
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
               A. aes_sbox used sequentially for 16 cycle for text compuation 
               B. 4 cycle for next round key computation
     0.2  - Nov 5, 2022
            A. Added 4 cycle pipe line mix column function -
            B. Moved all the counter and control to FSM logic
           
                                                              
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

module aes_inv_cipher_top(
        input logic         clk, 
        input logic         rstn, 
        input logic         kld, 
        input logic         ld, 
        output logic        kdone,
        output logic        done, 
        input logic [127:0] key, 
        input logic [127:0] text_in, 
        output logic [127:0] text_out 
      );

parameter IDLE        = 3'b000;
parameter KEY_DONE    = 3'b001;
parameter SBOX_DONE   = 3'b010;
parameter MIX_DONE    = 3'b011;
parameter NEXT_ROUND  = 3'b100;
parameter WAIT_LD     = 3'b101;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

wire	[31:0]	wk0, wk1, wk2, wk3;
reg	[31:0]	w0, w1, w2, w3;
reg	[7:0]	sa00, sa01, sa02, sa03;
reg	[7:0]	sa10, sa11, sa12, sa13;
reg	[7:0]	sa20, sa21, sa22, sa23;
reg	[7:0]	sa30, sa31, sa32, sa33;
wire	[7:0]	sa00_next, sa01_next, sa02_next, sa03_next;
wire	[7:0]	sa10_next, sa11_next, sa12_next, sa13_next;
wire	[7:0]	sa20_next, sa21_next, sa22_next, sa23_next;
wire	[7:0]	sa30_next, sa31_next, sa32_next, sa33_next;
wire	[7:0]	sa00_sub, sa01_sub, sa02_sub, sa03_sub;
wire	[7:0]	sa10_sub, sa11_sub, sa12_sub, sa13_sub;
wire	[7:0]	sa20_sub, sa21_sub, sa22_sub, sa23_sub;
wire	[7:0]	sa30_sub, sa31_sub, sa32_sub, sa33_sub;
wire	[7:0]	sa00_sr, sa01_sr, sa02_sr, sa03_sr;
wire	[7:0]	sa10_sr, sa11_sr, sa12_sr, sa13_sr;
wire	[7:0]	sa20_sr, sa21_sr, sa22_sr, sa23_sr;
wire	[7:0]	sa30_sr, sa31_sr, sa32_sr, sa33_sr;
wire	[7:0]	sa00_ark, sa01_ark, sa02_ark, sa03_ark;
wire	[7:0]	sa10_ark, sa11_ark, sa12_ark, sa13_ark;
wire	[7:0]	sa20_ark, sa21_ark, sa22_ark, sa23_ark;
wire	[7:0]	sa30_ark, sa31_ark, sa32_ark, sa33_ark;
wire            key_rdy;
logic 		    ld_r;
logic 	[3:0]   dcnt;
logic  [3:0]    scnt; // Step count, number step/cycle need to complete one round
logic  [1:0]    mcnt; // Mix count, number cycle need to complete column mix
logic  [3:0]    kcnt; // Next Key 
logic           active_s; // indicate active sbox phase
logic           active_m; // indicate active mix phase
logic           active_k; // indicate active mix phase
logic           nxt_step;
logic           done_pre;
logic [2:0]     state;


always @(posedge clk or negedge rstn) begin
   if(!rstn) begin
       done     <= 1'b0;
       done_pre <= 1'b0; 
       dcnt     <= 4'h0;
       kcnt     <= 4'h0;
       scnt     <= 4'h0;
       mcnt     <= 2'h0;
       active_k <= 1'b0;
       active_s <= 1'b0;
       active_m <= 1'b0;
       nxt_step <= 1'b0;
       kdone    <= 1'b0;
       state    <= IDLE;
   end else begin
      case(state)
      IDLE: begin
           done     <= done_pre; // Generate One cycle delayed
           done_pre <= 1'b0; 
           if(kld) begin
              dcnt     <= 4'h0;
              kcnt     <= 4'ha;
              active_k <= 1'b1;
              state    <= KEY_DONE;
           end
        end
      // Wait for all Key generation 
      // Note: Decription uses last Key first
      KEY_DONE: begin
	       if(key_rdy)	begin
              if(kcnt == 0) begin
                 kdone    <= 1'b1;
                 dcnt     <= 4'h0;
                 active_k <= 1'b0;
                 state    <= WAIT_LD;
              end else begin
                 kcnt <= kcnt - 4'h1;
              end
           end
        end
      WAIT_LD: begin
          kdone    <= 1'b0;
          if(ld) begin
             state     <= NEXT_ROUND;
          end
      end
      NEXT_ROUND: begin
           nxt_step  <= 0;
           if(dcnt == 4'ha) begin 
              done_pre <= 1;
              state    <= IDLE;
           end else begin
              scnt      <= 4'h0;
              active_s  <= 1'b1;
              dcnt     <= dcnt + 4'h1;
              state    <= SBOX_DONE;
           end
      end
      SBOX_DONE: begin
           nxt_step <= 1'b0;
           if(scnt == 4'hF) begin
              active_s  <= 1'b0;
              active_m  <= 1'b1;
              mcnt      <= 2'h0;
              state     <= MIX_DONE;
           end else begin
              scnt <= scnt + 1;
           end
        end
      MIX_DONE: begin
           if(mcnt == 2'h3) begin
              nxt_step  <= 1;
              active_s  <= 1'b0;
              active_m  <= 1'b0;
              state     <= NEXT_ROUND;
           end else begin
              mcnt <= mcnt + 1;
           end
      end
      endcase
   end
end
        


////////////////////////////////////////////////////////////////////
//
// Misc Logic
//

always @(posedge clk)	ld_r <= #1 ld;


////////////////////////////////////////////////////////////////////
//
// Initial Permutation
//

always @(posedge clk)	sa33 <= #1 ld_r ? text_in[007:000] ^ w3[07:00] : (nxt_step) ? sa33_next :sa33  ;
always @(posedge clk)	sa23 <= #1 ld_r ? text_in[015:008] ^ w3[15:08] : (nxt_step) ? sa23_next :sa23  ;
always @(posedge clk)	sa13 <= #1 ld_r ? text_in[023:016] ^ w3[23:16] : (nxt_step) ? sa13_next :sa13  ;
always @(posedge clk)	sa03 <= #1 ld_r ? text_in[031:024] ^ w3[31:24] : (nxt_step) ? sa03_next :sa03  ;
always @(posedge clk)	sa32 <= #1 ld_r ? text_in[039:032] ^ w2[07:00] : (nxt_step) ? sa32_next :sa32  ;
always @(posedge clk)	sa22 <= #1 ld_r ? text_in[047:040] ^ w2[15:08] : (nxt_step) ? sa22_next :sa22  ;
always @(posedge clk)	sa12 <= #1 ld_r ? text_in[055:048] ^ w2[23:16] : (nxt_step) ? sa12_next :sa12  ;
always @(posedge clk)	sa02 <= #1 ld_r ? text_in[063:056] ^ w2[31:24] : (nxt_step) ? sa02_next :sa02  ;
always @(posedge clk)	sa31 <= #1 ld_r ? text_in[071:064] ^ w1[07:00] : (nxt_step) ? sa31_next :sa31  ;
always @(posedge clk)	sa21 <= #1 ld_r ? text_in[079:072] ^ w1[15:08] : (nxt_step) ? sa21_next :sa21  ;
always @(posedge clk)	sa11 <= #1 ld_r ? text_in[087:080] ^ w1[23:16] : (nxt_step) ? sa11_next :sa11  ;
always @(posedge clk)	sa01 <= #1 ld_r ? text_in[095:088] ^ w1[31:24] : (nxt_step) ? sa01_next :sa01  ;
always @(posedge clk)	sa30 <= #1 ld_r ? text_in[103:096] ^ w0[07:00] : (nxt_step) ? sa30_next :sa30  ;
always @(posedge clk)	sa20 <= #1 ld_r ? text_in[111:104] ^ w0[15:08] : (nxt_step) ? sa20_next :sa20  ;
always @(posedge clk)	sa10 <= #1 ld_r ? text_in[119:112] ^ w0[23:16] : (nxt_step) ? sa10_next :sa10  ;
always @(posedge clk)	sa00 <= #1 ld_r ? text_in[127:120] ^ w0[31:24] : (nxt_step) ? sa00_next :sa00  ;

////////////////////////////////////////////////////////////////////
//
// Round Permutations
//

assign sa00_sr = sa00;
assign sa01_sr = sa01;
assign sa02_sr = sa02;
assign sa03_sr = sa03;
assign sa10_sr = sa13;
assign sa11_sr = sa10;
assign sa12_sr = sa11;
assign sa13_sr = sa12;
assign sa20_sr = sa22;
assign sa21_sr = sa23;
assign sa22_sr = sa20;
assign sa23_sr = sa21;
assign sa30_sr = sa31;
assign sa31_sr = sa32;
assign sa32_sr = sa33;
assign sa33_sr = sa30;
assign sa00_ark = sa00_sub ^ w0[31:24];
assign sa01_ark = sa01_sub ^ w1[31:24];
assign sa02_ark = sa02_sub ^ w2[31:24];
assign sa03_ark = sa03_sub ^ w3[31:24];
assign sa10_ark = sa10_sub ^ w0[23:16];
assign sa11_ark = sa11_sub ^ w1[23:16];
assign sa12_ark = sa12_sub ^ w2[23:16];
assign sa13_ark = sa13_sub ^ w3[23:16];
assign sa20_ark = sa20_sub ^ w0[15:08];
assign sa21_ark = sa21_sub ^ w1[15:08];
assign sa22_ark = sa22_sub ^ w2[15:08];
assign sa23_ark = sa23_sub ^ w3[15:08];
assign sa30_ark = sa30_sub ^ w0[07:00];
assign sa31_ark = sa31_sub ^ w1[07:00];
assign sa32_ark = sa32_sub ^ w2[07:00];
assign sa33_ark = sa33_sub ^ w3[07:00];

//------------------------------------------------------------------------------------
// To Reduce the total area of the aes, we have divided the mix_col access to 4 cycle
//------------------------------------------------------------------------------------
logic [31:0] mcol_arry[0:3];
logic [31:0] mcol_in;
logic [31:0] mcol_out;

always @(posedge clk)
begin
   mcol_arry[mcnt] <=  mcol_out;
end

always_comb
begin
  mcol_in = 0;
  case(mcnt)
  'h0:  mcol_in = {sa00_ark,sa10_ark,sa20_ark,sa30_ark};
  'h1:  mcol_in = {sa01_ark,sa11_ark,sa21_ark,sa31_ark};
  'h2:  mcol_in = {sa02_ark,sa12_ark,sa22_ark,sa32_ark};
  'h3:  mcol_in = {sa03_ark,sa13_ark,sa23_ark,sa33_ark};
  endcase
end

assign mcol_out = inv_mix_col(mcol_in[31:24],mcol_in[23:16],mcol_in[15:8],mcol_in[7:0]);

assign {sa00_next, sa10_next, sa20_next, sa30_next}  = mcol_arry[0];
assign {sa01_next, sa11_next, sa21_next, sa31_next}  = mcol_arry[1];
assign {sa02_next, sa12_next, sa22_next, sa32_next}  = mcol_arry[2];
assign {sa03_next, sa13_next, sa23_next, sa33_next}  = mcol_arry[3];

/**
assign {sa00_next, sa10_next, sa20_next, sa30_next} = inv_mix_col(sa00_ark,sa10_ark,sa20_ark,sa30_ark);
assign {sa01_next, sa11_next, sa21_next, sa31_next} = inv_mix_col(sa01_ark,sa11_ark,sa21_ark,sa31_ark);
assign {sa02_next, sa12_next, sa22_next, sa32_next} = inv_mix_col(sa02_ark,sa12_ark,sa22_ark,sa32_ark);
assign {sa03_next, sa13_next, sa23_next, sa33_next} = inv_mix_col(sa03_ark,sa13_ark,sa23_ark,sa33_ark);
***/

////////////////////////////////////////////////////////////////////
//
// Final Text Output
//

always @(posedge clk) if(done_pre) text_out[127:120] <= sa00_ark;
always @(posedge clk) if(done_pre) text_out[095:088] <= sa01_ark;
always @(posedge clk) if(done_pre) text_out[063:056] <= sa02_ark;
always @(posedge clk) if(done_pre) text_out[031:024] <= sa03_ark;
always @(posedge clk) if(done_pre) text_out[119:112] <= sa10_ark;
always @(posedge clk) if(done_pre) text_out[087:080] <= sa11_ark;
always @(posedge clk) if(done_pre) text_out[055:048] <= sa12_ark;
always @(posedge clk) if(done_pre) text_out[023:016] <= sa13_ark;
always @(posedge clk) if(done_pre) text_out[111:104] <= sa20_ark;
always @(posedge clk) if(done_pre) text_out[079:072] <= sa21_ark;
always @(posedge clk) if(done_pre) text_out[047:040] <= sa22_ark;
always @(posedge clk) if(done_pre) text_out[015:008] <= sa23_ark;
always @(posedge clk) if(done_pre) text_out[103:096] <= sa30_ark;
always @(posedge clk) if(done_pre) text_out[071:064] <= sa31_ark;
always @(posedge clk) if(done_pre) text_out[039:032] <= sa32_ark;
always @(posedge clk) if(done_pre) text_out[007:000] <= sa33_ark;

////////////////////////////////////////////////////////////////////
//
// Generic Functions
//

function [31:0] inv_mix_col;
input	[7:0]	s0,s1,s2,s3;
begin
inv_mix_col[31:24]=pmul_e(s0)^pmul_b(s1)^pmul_d(s2)^pmul_9(s3);
inv_mix_col[23:16]=pmul_9(s0)^pmul_e(s1)^pmul_b(s2)^pmul_d(s3);
inv_mix_col[15:08]=pmul_d(s0)^pmul_9(s1)^pmul_e(s2)^pmul_b(s3);
inv_mix_col[07:00]=pmul_b(s0)^pmul_d(s1)^pmul_9(s2)^pmul_e(s3);
end
endfunction

// Some synthesis tools don't like xtime being called recursevly ...
function [7:0] pmul_e;
input [7:0] b;
reg [7:0] two,four,eight;
begin
two=xtime(b);four=xtime(two);eight=xtime(four);pmul_e=eight^four^two;
end
endfunction

function [7:0] pmul_9;
input [7:0] b;
reg [7:0] two,four,eight;
begin
two=xtime(b);four=xtime(two);eight=xtime(four);pmul_9=eight^b;
end
endfunction

function [7:0] pmul_d;
input [7:0] b;
reg [7:0] two,four,eight;
begin
two=xtime(b);four=xtime(two);eight=xtime(four);pmul_d=eight^four^b;
end
endfunction

function [7:0] pmul_b;
input [7:0] b;
reg [7:0] two,four,eight;
begin
two=xtime(b);four=xtime(two);eight=xtime(four);pmul_b=eight^two^b;
end
endfunction

function [7:0] xtime;
input [7:0] b;xtime={b[6:0],1'b0}^(8'h1b&{8{b[7]}});
endfunction

////////////////////////////////////////////////////////////////////
//
// Key Buffer
//

reg	[127:0]	kb[10:0];

always @(posedge clk)	if(key_rdy)       kb[kcnt] <= {wk3, wk2, wk1, wk0};
always @(posedge clk)	if(dcnt != 4'hb)  {w3, w2, w1, w0} <= kb[dcnt];

////////////////////////////////////////////////////////////////////
//
// Modules
//
wire knxt = key_rdy & (kcnt != 0);

aes_key_expand_128 u0(
	.clk    ( clk	    ),
    .rstn   ( rstn      ),
	.kld    ( kld	    ),
	.key    ( key	    ),
    .knxt   ( knxt      ),
    .key_rdy( key_rdy   ),
	.wo_0   ( wk0	    ),
	.wo_1   ( wk1	    ),
	.wo_2   ( wk2	    ),
	.wo_3   ( wk3	    ));

//------------------------------------------------------------------------------------
// To Reduce the total area of the aes, we have divided the sbox access to 16 cycle
//------------------------------------------------------------------------------------
reg [7:0] sbox_arry[0:15];
reg [7:0] sbox_in;
reg [7:0] sbox_out;

always @(posedge clk)
begin
     if(active_s) sbox_arry[scnt] <=  sbox_out;
end

always_comb
begin
  sbox_in = 0;
  case(scnt)
  'h0:  sbox_in =sa00_sr ;
  'h1:  sbox_in =sa01_sr ;
  'h2:  sbox_in =sa02_sr ;
  'h3:  sbox_in =sa03_sr ;
  'h4:  sbox_in =sa10_sr ;
  'h5:  sbox_in =sa11_sr ;
  'h6:  sbox_in =sa12_sr ;
  'h7:  sbox_in =sa13_sr ;
  'h8:  sbox_in =sa20_sr ;
  'h9:  sbox_in =sa21_sr ;
  'hA:  sbox_in =sa22_sr ;
  'hB:  sbox_in =sa23_sr ;
  'hC:  sbox_in =sa30_sr ;
  'hD:  sbox_in =sa31_sr ;
  'hE:  sbox_in =sa32_sr ;
  'hF:  sbox_in =sa33_sr ;
  endcase
end

assign sa00_sub=sbox_arry[0];
assign sa01_sub=sbox_arry[1];
assign sa02_sub=sbox_arry[2];
assign sa03_sub=sbox_arry[3];
assign sa10_sub=sbox_arry[4];
assign sa11_sub=sbox_arry[5];
assign sa12_sub=sbox_arry[6];
assign sa13_sub=sbox_arry[7];
assign sa20_sub=sbox_arry[8];
assign sa21_sub=sbox_arry[9];
assign sa22_sub=sbox_arry[10];
assign sa23_sub=sbox_arry[11];
assign sa30_sub=sbox_arry[12];
assign sa31_sub=sbox_arry[13];
assign sa32_sub=sbox_arry[14];
assign sa33_sub=sbox_arry[15];

aes_inv_sbox u_sbox(	.a(	sbox_in	), .d(	sbox_out	));

/***
aes_inv_sbox us00(	.a(	sa00_sr	),	.d(	sa00_sub	));
aes_inv_sbox us01(	.a(	sa01_sr	),	.d(	sa01_sub	));
aes_inv_sbox us02(	.a(	sa02_sr	),	.d(	sa02_sub	));
aes_inv_sbox us03(	.a(	sa03_sr	),	.d(	sa03_sub	));
aes_inv_sbox us10(	.a(	sa10_sr	),	.d(	sa10_sub	));
aes_inv_sbox us11(	.a(	sa11_sr	),	.d(	sa11_sub	));
aes_inv_sbox us12(	.a(	sa12_sr	),	.d(	sa12_sub	));
aes_inv_sbox us13(	.a(	sa13_sr	),	.d(	sa13_sub	));
aes_inv_sbox us20(	.a(	sa20_sr	),	.d(	sa20_sub	));
aes_inv_sbox us21(	.a(	sa21_sr	),	.d(	sa21_sub	));
aes_inv_sbox us22(	.a(	sa22_sr	),	.d(	sa22_sub	));
aes_inv_sbox us23(	.a(	sa23_sr	),	.d(	sa23_sub	));
aes_inv_sbox us30(	.a(	sa30_sr	),	.d(	sa30_sub	));
aes_inv_sbox us31(	.a(	sa31_sr	),	.d(	sa31_sub	));
aes_inv_sbox us32(	.a(	sa32_sr	),	.d(	sa32_sub	));
aes_inv_sbox us33(	.a(	sa33_sr	),	.d(	sa33_sub	));
***/

endmodule

