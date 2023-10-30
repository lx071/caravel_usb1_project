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
                                                              
                   AES RCON Block
                                                              
  Description:                                                 
     
                                                              
  Author(s):                                                  
      - Rudolf Usselmann ,rudi@asics.ws                        
      - Dinesh Annayya, dinesh.annayya@gmail.com                 
                                                              
  Revision :                                                  
     0.0  - Oct 15, 2022 
            Initial Version picked from https://opencores.org/ocsvn/aes_core                                    
           
                                                              
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


module aes_rcon(
    input logic         clk, 
    input logic         kld, 
    input logic         knxt,
    output logic [31:0] out);



reg	[3:0]	    rcnt;
wire	[3:0]	rcnt_next;

always @(posedge clk)
	if(kld)		        out <= #1 32'h01_00_00_00;
	else if(knxt)		out <= #1 frcon(rcnt_next);

assign rcnt_next = rcnt + 4'h1;
always @(posedge clk)
	if(kld)		        rcnt <= #1 4'h0;
	else if(knxt)		rcnt <= #1 rcnt_next;

function [31:0]	frcon;
input	[3:0]	i;
case(i)	// synopsys parallel_case
   4'h0: frcon=32'h01_00_00_00;
   4'h1: frcon=32'h02_00_00_00;
   4'h2: frcon=32'h04_00_00_00;
   4'h3: frcon=32'h08_00_00_00;
   4'h4: frcon=32'h10_00_00_00;
   4'h5: frcon=32'h20_00_00_00;
   4'h6: frcon=32'h40_00_00_00;
   4'h7: frcon=32'h80_00_00_00;
   4'h8: frcon=32'h1b_00_00_00;
   4'h9: frcon=32'h36_00_00_00;
   default: frcon=32'h00_00_00_00;
endcase
endfunction

endmodule
