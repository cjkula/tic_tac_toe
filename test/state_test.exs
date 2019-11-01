defmodule StateTest do
  use ExUnit.Case
  import State

  describe ".whose_turn" do
    test "on the first turn returns player one" do
      computer_first = state(player_one: :computer, moves: [])
      human_first = state(player_one: :human, moves: [])
      assert whose_turn(computer_first) == :computer
      assert whose_turn(human_first) == :human
    end

    test "on the second turn returns the other player" do
      computer_first = state(player_one: :computer, moves: [1])
      human_first = state(player_one: :human, moves: [1])
      assert whose_turn(computer_first) == :human
      assert whose_turn(human_first) == :computer
    end
  end

  describe ".valid_move?" do
    test "returns true if the number is not a previous move" do
      state = state(player_one: :computer, moves: [1])
      assert valid_move?(state, 2) == true
    end

    test "returns false if the number is a previous move" do
      state = state(player_one: :computer, moves: [1])
      assert valid_move?(state, 1) == false      
    end

    test "returns false if the number is out of range" do
      state = state(player_one: :computer, moves: [1])
      assert valid_move?(state, 0) == false      
      assert valid_move?(state, 10) == false      
    end
  end
end
