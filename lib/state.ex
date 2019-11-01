defmodule State do
  require Record
  Record.defrecord :state, [:player_one, :moves]

  # opening game state
  def initial(player_one) do
    state(player_one: player_one, moves: [])
  end

  # field convenience
  def player_one(state) do
    state(state, :player_one)
  end

  # invert result of .player_one()
  def player_two(state) do
    [:computer, :human]
    |> List.delete(player_one(state))
    |> List.first
  end

  # just the moves by X
  def player_one_moves(moves) do
    moves |> Enum.take_every(2)
  end

  # just the moves by O
  def player_two_moves(moves) do
    moves |> List.delete_at(0) |> Enum.take_every(2)
  end

  # moves for one specified player
  def moves(state, player) do
    moves = state(state, :moves)
    if player_one(state) == player do
      player_one_moves(moves)
    else
      player_two_moves(moves)
    end
  end

  # whose turn is it anyway?
  def whose_turn(state) do
    if rem(Enum.count(state(state, :moves)), 2) == 0 do
      player_one(state)
    else
      player_two(state)
    end
  end

  # is the move in range and unplayed?
  # does not check for valid integer type
  def valid_move?(state, move) do
    cond do
      move < 1 || move > 9 -> false
      state(state, :moves) |> Enum.any?(fn m -> m == move end) -> false
      true -> true
    end
  end

  # update state with a new move
  def apply_move(state, move) do
    state(state, moves: state(state, :moves) ++ [move])
  end

  # return the winner if there is one
  # :computer, :human, :cat, or nil
  def winner(state) do
    moves = state(state, :moves)

    cond do
      Logic.winning_moves?(player_one_moves(moves)) ->
        player_one(state)
      Logic.winning_moves?(player_two_moves(moves)) ->
        player_two(state)
      Enum.count(moves) == 9 ->
        :cat # game over, tie
      true ->
        nil # no winner yet
    end
  end
end