defmodule Logic do
  require State

  @wins [ [1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7] ]

  # does the set of moves (for one side) contains a win?
  def winning_moves?(moves) do
    Enum.any?(@wins, fn win -> win -- moves == [] end)
  end

  # apply cascading strategies for move choice
  def select_move(state) do
    win(state) || block(state) || random(state)
  end

  # win if you can!
  def win(state) do
    computer_moves = State.moves(state, :computer)
    human_moves = State.moves(state, :human)

    Enum.find_value(@wins, fn win -> winning_move(win, computer_moves, human_moves) end)
  end

  # block if you must!
  def block(state) do
    computer_moves = State.moves(state, :computer)
    human_moves = State.moves(state, :human)

    Enum.find_value(@wins, fn win -> winning_move(win, human_moves, computer_moves) end)
  end

  # just throw darts!
  def random(state) do
    move = Enum.random(1..9)
    if State.valid_move?(state, move), do: move, else: select_move(state)
  end

  # used to find both wins and blocks
  # is there is a 2 out of 3 for the offense? if so return the 3rd
  def winning_move(win_group, offense_moves, defence_moves) do
    if Enum.count(win_group -- defence_moves) == 3 do # not played in this group
      remaining = win_group -- offense_moves
      if Enum.count(remaining) == 1, do: List.first(remaining)
    end
  end
end