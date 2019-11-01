defmodule Board do
  require Record
  # squares: array[9] containing X, O, or nil
  # last_move: integer
  Record.defrecord :board, [:squares, :last_move]

  require State

  # translates a state with move list into a board array
  def from_state(state) do
    moves = State.state(state, :moves)

    squares =
      moves
      |> Enum.with_index
      |> Enum.reduce(List.duplicate(nil, 9), fn { move, index }, squares ->
        List.replace_at(squares, move - 1, (if rem(index, 2) == 0, do: "X", else: "O"))
      end)

    board(squares: squares, last_move: List.last(moves))
  end

  # ASCII board representation
  def display(board) do
    last_move = board(board, :last_move)
    squares = board(board, :squares)
    output =
      Enum.chunk_every(squares, 3)
      |> Enum.with_index
      |> Enum.map(fn { one_line, index } -> line(one_line, (if last_move, do: last_move - 1 - index * 3)) end)
      |> Enum.join("\n-----------\n")

    output <> "\n"
  end

  # horizontal board line
  def line(squares, highlight) do
    squares
    |> Enum.with_index
    |> Enum.map(fn { item, index } -> if index == highlight, do: ":#{item || " "}:", else: " #{item || " "} " end)
    |> Enum.join("|")
  end
end