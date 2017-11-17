require 'byebug'
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
    all_moves = find_all_moves(pieces).shuffle
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
  #
  # def minimaxRoot(depth, board, isMax)
  #   pieces = my_grid.flatten.select { |piece| piece.color == @color }
  #   all_moves = find_all_moves(pieces)
  #   x = @board.in_check(@color)
  #   if x
  #     all_moves = calculate_check_moves(all_moves, x)
  #   end
  #   best_value = -9999
  #   best_move = nil
  #   all_moves.each_with_index do |x, idx|
  #     new_move = x
  #
  #   end
  # end

  def calculate_best_move(moves)
    isMax = true
    to_print = nil
    checked = @board.in_check?(@color)
    if checked
      moves = calculate_check_moves(moves, checked)
    end
    best_value = -9999
    best_move = nil
    this = Time.now
    moves.each do |move_arr|
      start = move_arr[0]
      move_arr[1].each do |move|
        future = @board.deep_dup
        future.move_piece!(start, move)
        boardval = search_tree_for_move(2, future, -10000, 10000, !isMax)



        # boardval = evaluate_board(future, @color)
        if (boardval > best_value )
          best_move = [start, move]
          best_value = boardval


          to_print = best_value
        end
      end
    end
     p "this is the best move"
              p best_value
    print Time.now - this
    return best_move

  end


  def search_tree_for_move(depth, board, alpha, beta, isMax)

    color = isMax == true ? :black : :white

    if depth == 0
      # p evaluate_board(board, color)

      return evaluate_board(board, color)
    end
    my_grid = board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == color }
    moves = find_all_moves(pieces)
    checked = board.in_check?(color)
    if checked
      moves = calculate_check_moves(moves, checked)
    end
    if isMax
      best_move = -9999
      # pieces = board.grid.flatten.select { |piece| piece.color == @color }
      moves.each do |move_arr|
        start = move_arr[0]
        move_arr[1].each do |move|
          # future = board.dup
          future = board.deep_dup
          future.move_piece!(start, move)
          future_val = search_tree_for_move(depth - 1, future, alpha, beta, !isMax)
          best_move = best_move > future_val ? best_move : future_val
          # puts "\t" * depth + "black: " +  best_move.to_s
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
          start = move_arr[0]
          move_arr[1].each do |move|

            # future = board.dup
            future = board.deep_dup
            future.move_piece!(start, move)
            future_val = search_tree_for_move(depth - 1, future, alpha, beta, !isMax)
            best_move = best_move < future_val ? best_move : future_val
            beta = [beta, best_move].min
            if beta <= alpha
            # puts "\t" * depth + "white:" + best_move.to_s
              return best_move
            end
          end
        end
      # pieces = board.grid.flatten.select { |piece| piece.color != @color }
      return best_move
    end
  end



  def evaluate_board(future, color)
    pieces = future.grid.flatten.reject { |piece| piece.color == nil }
    boardval = pieces.reduce(0) do |acc, el|
      #
      if el.color == :black
        acc += PIECE_VALUES[el.class]
      else
        acc -= PIECE_VALUES[el.class]
      end
    end
    #
    return boardval
  end
end
