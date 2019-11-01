defmodule LogicTest do
  use ExUnit.Case
  import Logic

  describe ".win" do
    test "it completes a row for the win" do
      assert win({ State, :computer, [1, 4, 2, 5] }) == 3
      assert win({ State, :computer, [2, 1, 5, 3] }) == 8
      assert win({ State, :human, [1, 3, 2, 5, 4] }) == 7
    end
  end

  describe ".block" do
    test "it prevents a win" do
      assert block({ State, :human, [4, 3, 5] }) == 6
      assert block({ State, :human, [9, 5, 3] }) == 6
      assert block({ State, :computer, [7, 9, 8, 1] }) == 5
    end
  end
end