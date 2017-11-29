
class ComputerPlayer
  attr_reader :name, :color

  PIECE_VALUES = {
    Pawn => 10,
    Knight => 30,
    Bishop => 35,
    Rook => 50,
    Queen => 90,
    King => 900
  }

  def initialize(name, game, color, board, display)
    @name = name
    @game = game
    @color = color
    @board = board
    @other_color = @color == :black ? :white : :black
    @display = display
  end

  def play_turn
    my_grid = @board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == @color }
    all_moves = find_all_moves(pieces).shuffle
    move = calculate_best_move(all_moves)
    return move
  end


  def find_all_moves(pieces)
    moves = []
    pieces.each do |piece|
      goodmoves = piece.valid_moves
      # add start position and possible moves to moves array together.
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
    moves.select { |move| move[1].include?(threat) }
  end


  def calculate_best_move(moves)
      isMax = true
    to_print = nil
    best_value = -9999
    best_move = nil
    moves.each do |move_arr|
      start = move_arr[0]
      move_arr[1].each do |move|
        future = @board.deep_dup
        future.move_piece!(start, move)
        #Call minimax algorithm.
        boardval = search_tree_for_move(1, future, -10000, 10000, !isMax)
        if (boardval > best_value )
          best_move = [start, move]
          best_value = boardval
          to_print = best_value
        end
      end
    end
    if best_value >= -9999 || best_value <= 9999
      return best_move
    else
      if pick_random_move(moves) == nil
        puts "stalemate"
        return nil
      else
        return pick_random_move(moves)
      end
    end


  end

  def no_children?(move_arr)
    move_arr.empty? || move_arr.nil? ? true : false
  end

  def search_tree_for_move(depth, board, alpha, beta, isMax)
    color = isMax == true ? @color : @other_color

    if depth == 0
      return evaluate_board(board, color)
    end

    my_grid = board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == color }
    moves = find_all_moves(pieces)

    if moves.empty?
      return evaluate_board(board, color)
    end

    if isMax
      best_move = -9999
      moves.each do |move_arr|
        if move_arr.empty?
          val = evaluate_board(board, color)
          best_move = best_move > val ? best_move : val
          next
        end
        start = move_arr[0]
        move_arr[1].each do |move|
          future = board.deep_dup
          future.move_piece!(start, move)
          future_val = search_tree_for_move(depth - 1, future, alpha, beta, !isMax)
          best_move = best_move > future_val ? best_move : future_val
          alpha = [alpha, best_move].max

          if beta <= alpha
            return best_move
          end

        end
      end
      return best_move
    else
      best_move = 9999
      moves.each do |move_arr|
        if move_arr.empty?
          val = evaluate_board(board, color)
          best_move = best_move < val ? best_move : val
          next
        end
        start = move_arr[0]
        move_arr[1].each do |move|
          future = board.deep_dup
          future.move_piece!(start, move)
          future_val = search_tree_for_move(depth - 1, future, alpha, beta, !isMax)
          best_move = best_move < future_val ? best_move : future_val
          beta = [beta, best_move].min

          if beta <= alpha
            return best_move
          end

        end
      end
      return best_move
    end
  end



  def evaluate_board(future, color)
    pieces = future.grid.flatten.reject { |piece| piece.color == nil }
    boardval = pieces.reduce(0) do |acc, el|
      #
      if el.color == @color
        acc += PIECE_VALUES[el.class]
      else
        acc -= PIECE_VALUES[el.class]
      end
    end
    #
    return boardval
  end
end
