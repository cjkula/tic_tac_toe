defmodule Game do
  require Board
  require State

  # provide instructions, choose sides, and start first turn
  def start() do
    instructions()
    side = ask_side()
    IO.puts "\nYou are #{side}\n"
    player_one = if side == "X", do: :human, else: :computer

    turn(State.initial(player_one))
  end

  # show the board square numbering
  def instructions() do
    numbered = Board.board(squares: ~w(1 2 3 4 5 6 7 8 9)) |> Board.display
    IO.puts "\nPrepare to lose. Squares are numbered:\n\n#{numbered}\n"
  end

  # allow player to choose X or O
  def ask_side() do
    side =
      IO.gets("Do you want to be X or O? ")
      |> String.trim
      |> String.upcase

    if side == "X" || side == "O" do
      side
    else
      IO.puts "Try again."
      ask_side()
    end
  end

  # player or computer moves, state is updated, and any winner or tie declared
  # otherwise tail recursion for next move
  def turn(state) do
    new_state = do_move(state)
    IO.puts("\n" <> Board.display(Board.from_state(new_state)))

    case State.winner(new_state) do
      :computer ->
        IO.puts "You have lost, as expected!\n"
      :human ->
        IO.puts "You won?!! I demand a rematch!\n"
      :cat ->
        IO.puts "Our battle of wits is at an impasse... (A tie.) Another time, my poppet.\n"
      nil ->
        turn(new_state)
    end
  end

  # queries the player for a move or calculates best move
  # depending on whose move it is
  # then updates the game state
  def do_move(state) do
    move =
      if State.whose_turn(state) == :computer do
        m = Logic.select_move(state)
        IO.puts "My turn > #{m}"
        m
      else
        ask_turn(state, "Your turn > ")
      end

    State.apply_move(state, move)    
  end

  # query player for move, recurse on bad input
  def ask_turn(state, prompt) do
    case IO.gets(prompt) |> String.trim |> Integer.parse do
      { move, _ } when move > 0 and move < 10 -> 
        if State.valid_move?(state, move), do: move, else: ask_turn(state, "Invalid move > ")
      _ -> 
        ask_turn(state, "Invalid input, enter a number 1–9 > ")
    end
  end
end