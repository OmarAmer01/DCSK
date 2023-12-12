/*
================================================================================
* TX Finite State Machine.
* This FSM is the Control Unit of the Whole TX Module.

* Authors:
*    1. Omar Tarek Amer
*    2. Menna Tullah Ahmed

* Date: 12/11/2023
=================================================================================
*/

module tx_fsm (
    input              i_clk,
    input              i_arst_n,
    input              i_send,
    input  logic [9:0] i_bit_ctr,
    input  logic [4:0] i_chip_ctr,
    input              i_chip_ctr_msb,
    input  logic [9:0] i_wrap_around,

    output logic       o_shift_chaos_bit,
    output logic       o_shift_msg_bit,
    output logic       o_load_msg,
    output logic       o_en_bit_chip_ctr,
    output logic       o_is_sending
);

  typedef enum logic {
    IDLE,
    SEND
  } states_t;
  states_t current, next;

  always_ff @(posedge i_clk or negedge i_arst_n) begin : state_advancer
    if (~i_arst_n) current <= IDLE;
    else current <= next;
  end

  always_comb begin : next_state_logic
    case (current)
      IDLE: begin
        next = i_send ? SEND : IDLE;
      end

      SEND: begin
        if (i_bit_ctr == i_wrap_around) next = i_send ? SEND : IDLE;
        else next = SEND;
      end

      default: next = states_t'('X);
    endcase
  end

  logic shift_msg;

  always_comb begin : output_generation

    //! No latches.
    o_shift_chaos_bit = 1'b0;
    o_shift_msg_bit   = 1'b0;
    o_load_msg        = 1'b0;
    o_en_bit_chip_ctr = 1'b0;
    o_is_sending      = 1'b0;

    case (current)
      IDLE: begin
        o_shift_chaos_bit = 1'b0;
        o_shift_msg_bit   = 1'b0;
        o_load_msg        = i_send;
        o_en_bit_chip_ctr = 1'b0;
        o_is_sending      = 1'b0;
      end

      SEND: begin
        o_shift_chaos_bit = ~i_chip_ctr_msb;
        o_shift_msg_bit   = shift_msg & (i_bit_ctr != 0);
        o_load_msg        = (i_bit_ctr == i_wrap_around) & i_send;
        o_en_bit_chip_ctr = 1'b1;
        o_is_sending      = 1'b1;
      end

      default: begin

      end
    endcase

  end

  //! We need to detect the falling edge of the chip counter MSB
  //! to load the next msg bit.

  negedge_detector U_negedge_detector (
      .i_clk(i_clk),
      .i_arst_n(i_arst_n),
      .i_signal(i_chip_ctr_msb),
      .negedge_detected(shift_msg)
  );

endmodule
