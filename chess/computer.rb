
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

  def initialize(name, game, color, board, display, depth)
    @name = name
    @game = game
    @color = color
    @board = board
    @other_color = @color == :black ? :white : :black
    @display = display
    @depth = depth
  end

  def play_turn
    system "clear"
    puts "#{@color}'s turn"
    @display.render
    my_grid = @board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == @color }
    all_moves = find_all_moves(pieces).shuffle
    start = Time.now
    move = get_best_move(all_moves)
    nd = Time.now
    et = nd - start
    system "clear"
    puts 'that took: '
    puts et
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

  def get_best_move(all_moves)
    chunked = all_moves.each_slice(4).to_a
    p chunked
    p chunked.size
    moves = chunked.map do |moves|
      ractor_args = Marshal.dump({ board: @board, moves: moves, depth: @depth, color: @color, other_color: @other_color })
      get_val_with_ractor(ractor_args)
    end

    moves.map(&:take).max_by { |h| h[:val]}[:move]
  end

  def get_val_with_ractor(ractor_args)
    Ractor.new(ractor_args) do |ractor_args|
      msg = Marshal.load(ractor_args)
      brd = msg[:board]
      moves = msg[:moves]
      depth = msg[:depth]
      color = msg[:color]
      other_color = msg[:other_color]
      MoveCalculator.new.calculate_best_move(moves, depth, brd, color, other_color)
    end
  end
end

class MoveCalculator
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

  def calculate_best_move(moves, depth, board, color, other_color)
    isMax = true
    best_value = -9999
    best_move = nil
    depth = depth
    moves.each do |move_arr|
      start = move_arr[0]
      move_arr[1].each do |move|
        future = board.deep_dup
        future.move_piece!(start, move)
        #Call minimax algorithm.
        boardval = search_tree_for_move(depth, future, -10000, 10000, !isMax, color, other_color)
        if (boardval > best_value )
          best_move = [start, move]
          best_value = boardval
        end
      end
    end
    if best_value >= -9999 || best_value <= 9999
      return {move: best_move, val: best_value}
    else
      if pick_random_move(moves) == nil
        puts "stalemate"
        return nil
      else
        return { move: pick_random_move(moves), val: best_value }
      end
    end
  end

  def search_tree_for_move(depth, board, alpha, beta, isMax, color1, other_color1)
    color = isMax == true ? color1 : other_color1

    if depth == 0
      return evaluate_board(board, color, color1)
    end

    my_grid = board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == color }
    moves = find_all_moves(pieces)

    if moves.empty?
      return evaluate_board(board, color, color1)
    end

    if isMax
      best_move = -9999
      moves.each do |move_arr|
        if move_arr.empty?
          val = evaluate_board(board, color, color1)
          best_move = best_move > val ? best_move : val
          next
        end
        start = move_arr[0]
        move_arr[1].each do |move|
          future = board.deep_dup
          future.move_piece!(start, move)
          future_val = search_tree_for_move(depth - 1, future, alpha, beta, !isMax, color1, other_color1)
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
          val = evaluate_board(board, color, color1)
          best_move = best_move < val ? best_move : val
          next
        end
        start = move_arr[0]
        move_arr[1].each do |move|
          future = board.deep_dup
          future.move_piece!(start, move)
          future_val = search_tree_for_move(depth - 1, future, alpha, beta, !isMax, color1, other_color1)
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

  def evaluate_board(future, color, color1)
    piece_values = {
      Pawn => 10,
      Knight => 30,
      Bishop => 35,
      Rook => 50,
      Queen => 90,
      King => 900
    }
    pieces = future.grid.flatten.reject { |piece| piece.color == nil }
    boardval = pieces.reduce(0) do |acc, el|
      if el.color == color1
        acc += piece_values[el.class]
      else
        acc -= piece_values[el.class]
      end
    end
    return boardval
  end
end
