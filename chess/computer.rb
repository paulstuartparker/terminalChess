class ComputerPlayer
  attr_reader :name, :color

  PIECE_VALUES = {
    Pawn => 10,
    Knight => 30,
    Bishop => 30,
    Rook => 50,
    Queen => 90,
    King => 900
  }

  def initialize(name, game, color, board, display)
    @name = name
    @game = game
    @color = color
    @board = board
    @display = display
  end

  def play_turn
    my_grid = @board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == @color }
    all_moves = find_all_moves(pieces)
    move = calculate_best_move(all_moves)
    # move = search_tree_for_move(pieces, 4, @board)
    # move = pick_random_move(all_moves)
    return move
  end


  def find_all_moves(pieces)
    moves = []
    pieces.each do |piece|
      goodmoves = piece.valid_moves
      moves << [piece.pos, goodmoves]
    end
    parsed_moves = moves.select { |move| move[1] != []}
    return parsed_moves
  end

  def pick_random_move(moves)
    parsed_moves = moves.select { |move| move[1] != []}
    move_piece = parsed_moves.sample
    start = move_piece[0]
    end_pos = move_piece[1].sample
    return [start, end_pos]
  end

  def calculate_check_moves(moves, threat)
    moves.select { |move| move[1].include?(threat)}
  end

  # def search_tree_for_move(depth, board, computer)
  #   if depth == 0
  #     return evaluate_board(board)
  #   end
  #   depth = 4
  #   moves = find_all_moves(pieces)
  #   if computer
  #     best_move = -9999
  #     pieces = board.grid.flatten.select { |piece| piece.color == @color }
  #     moves.each do |move_arr|
  #       start = move_arr[0]
  #       move_arr[1].each do |move|
  #       future = board.dup
  #
  #
  #
  #   else
  #     pieces = board.grid.flatten.select { |piece| piece.color != @color }
  #   end
  # end

  def calculate_best_move(moves)
    x = @board.in_check?(@color)
    if x
      moves = calculate_check_moves(moves, x)
    end
    best_value = -9999
    best_move = nil
    moves.each do |move_arr|
      start = move_arr[0]
      move_arr[1].each do |move|
        future = @board.dup
        future.move_piece!(start, move)
        boardval = evaluate_board(future)
        if (boardval > best_value )
          best_move = [start, move]
        end
      end
    end
    # debugger
    return best_move

  end


  def evaluate_board(future)
    pieces = future.grid.flatten.reject { |piece| piece.color == nil }
    boardval = pieces.reduce(0) do |acc, el|
      # debugger
      if el.color == @color
        acc += PIECE_VALUES[el.class]
      else
        acc -= PIECE_VALUES[el.class]
      end
    end
    # debugger
    return boardval
  end
end
