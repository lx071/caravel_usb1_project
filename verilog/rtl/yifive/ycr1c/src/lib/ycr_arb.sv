//////////////////////////////////////////////////////////////////////////////
// SPDX-FileCopyrightText: 2021 , Dinesh Annayya                          
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0
// SPDX-FileContributor: Created by Dinesh Annayya <dinesha@opencores.org>
//
//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Arbitor                                                     ////
////                                                              ////
////  This file is part of the YIFive cores project               ////
////  https://github.com/dineshannayya/ycr.git                   ////
////  http://www.opencores.org/cores/yifive/                      ////
////                                                              ////
////  Description                                                 ////
////      This block implement simple round robine request        ////
//        arbitor for core interface.                             ////
////                                                              ////
////  To Do:                                                      ////
////    nothing                                                   ////
////                                                              ////
////  Author(s):                                                  ////
////      - Dinesh Annayya, dinesha@opencores.org                 ////
////                                                              ////
////  Revision :                                                  ////
////    0.1 - 20 Jan 2022, Dinesh A                               ////
////         Initial Version                                      ////
////                                                              ////
//////////////////////////////////////////////////////////////////////
////                                                              ////
//// Copyright (C) 2000 Authors and OPENCORES.ORG                 ////
////                                                              ////
//// This source file may be used and distributed without         ////
//// restriction provided that this copyright statement is not    ////
//// removed from the file and that any derivative work contains  ////
//// the original copyright notice and the associated disclaimer. ////
////                                                              ////
//// This source file is free software; you can redistribute it   ////
//// and/or modify it under the terms of the GNU Lesser General   ////
//// Public License as published by the Free Software Foundation; ////
//// either version 2.1 of the License, or (at your option) any   ////
//// later version.                                               ////
////                                                              ////
//// This source is distributed in the hope that it will be       ////
//// useful, but WITHOUT ANY WARRANTY; without even the implied   ////
//// warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      ////
//// PURPOSE.  See the GNU Lesser General Public License for more ////
//// details.                                                     ////
////                                                              ////
//// You should have received a copy of the GNU Lesser General    ////
//// Public License along with this source; if not, download it   ////
//// from http://www.opencores.org/lgpl.shtml                     ////
////                                                              ////
//////////////////////////////////////////////////////////////////////


module ycr_arb #(parameter TREQ = 2,
                 parameter TREQ_DW   = $clog2(TREQ))
(
	input logic             clk, 
	input logic             rstn, 
	input logic [TREQ-1:0]  req,  // Request
	input logic             req_ack,  // Request
	input logic             lack,  // Ack
	output logic [TREQ_DW:0]gnt   // Grant
       );

///////////////////////////////////////////////////////////////////////
//
// Parameters
//


parameter       FSM_GRANT      = 2'b00,
                WAIT_REQ_ACK   = 2'b01,
                WAIT_LACK      = 2'b10;


parameter       GRANT0     = {TREQ_DW+1{1'b0}}; // ALl Zero
parameter       GRANTX     = {TREQ_DW+1{1'b1}}; // All One

///////////////////////////////////////////////////////////////////////
// Local Registers and Wires
//////////////////////////////////////////////////////////////////////

reg [1:0]     	    state, next_state;
reg [TREQ_DW:0]    next_gnt,grnt_tmp;
reg [TREQ_DW-1:0]  ngnt,next_ngnt; // 1 Bit less than gnt to take care of roll over

///////////////////////////////////////////////////////////////////////
//  Misc Logic 
//////////////////////////////////////////////////////////////////////


always@(posedge clk or negedge rstn)
    if(!rstn) begin
       state   <= FSM_GRANT;
       gnt     <= GRANTX;
       ngnt    <= GRANT0;
    end else begin		
       gnt      <= next_gnt;
       ngnt     <= next_ngnt;
       state    <= next_state;
    end

///////////////////////////////////////////////////////////////////////
//
// Next State Logic 
//   - implements round robin arbitration algorithm
//   - switches grant if current req is dropped or next is asserted
//   - parks at last grant
//////////////////////////////////////////////////////////////////////


always_comb
   begin
      grnt_tmp      = 'h0;
      next_gnt      = gnt;
      next_ngnt     = ngnt;       
      next_state    = state;	// Default Keep State
      case(state)		
	 FSM_GRANT: begin
	     grnt_tmp = get_gnt({req,req},ngnt);
	     // Switch state only on req_ack, 
	     // To take care of case, where risc core can abrutly can
	     // de-assert req, do take care of jump cases
	     if(grnt_tmp != GRANTX) begin
		 next_gnt  = {1'b0,grnt_tmp[TREQ_DW-1:0]};
		 if(req_ack) begin
	            grnt_tmp =  next_gnt+1;
		    next_ngnt =   grnt_tmp[TREQ_DW-1:0];
	     	    next_state   = WAIT_LACK;
	         end else begin
	     	    next_state   = WAIT_REQ_ACK;
	         end
	     end 
      	end
	 WAIT_REQ_ACK: begin
	      if(req_ack) begin
	         grnt_tmp      =next_gnt+1;
		 next_ngnt    = grnt_tmp[TREQ_DW-1:0];
	     	 next_state   = WAIT_LACK;
	      end else if(req[gnt] == 0) begin // Exit if request is abortly removed
	     	 next_state   = FSM_GRANT;
	     end 
      	end
	WAIT_LACK : begin
		if(lack) begin
	     	    next_gnt     = GRANTX;
	     	    next_state   = FSM_GRANT;
		end
	end
      endcase
   end


function [TREQ_DW:0] get_gnt;
input [15:0] req; // 2*N request
input [TREQ_DW:0]  cur_gnt; // current grnt id
integer index;
begin 
   get_gnt = GRANTX;
   for(index=0;index  < TREQ;index=index+1)
   begin
      if(req[cur_gnt+index] ) 
   	get_gnt      = cur_gnt+index;
   end
end
endfunction


endmodule 
