require 'byebug'
class ComputerPlayer
  attr_reader :name, :color

  PIECE_VALUES = {
    Pawn => 100,
    Knight => 300,
    Bishop => 350,
    Rook => 500,
    Queen => 900,
    King => 20000
  }

  WHITE_MOVE_TABLE = {  Pawn =>[[900,  900,  900,  900,  900,  900,  900,  900],
                    [50, 50, 50, 50, 50, 50, 50, 50],
                    [10, 10, 20, 30, 30, 20, 10, 10],
                    [5,  5, 10, 25, 25, 10,  5,  5],
                    [0,  0,  0, 20, 20,  0,  0,  0],
                    [5, -5,-10,  0,  0,-10, -5,  5],
                    [5, 10, 10,-20,-20, 10, 10,  5],
                    [0,  0,  0,  0,  0,  0,  0,  0]],
          Knight => [[-50,-40,-30,-30,-30,-30,-40,-50],
                    [-40,-20,  0,  0,  0,  0,-20,-40],
                    [-30,  0, 10, 15, 15, 10,  0,-30],
                    [-30,  5, 15, 20, 20, 15,  5,-30],
                    [-30,  0, 15, 20, 20, 15,  0,-30],
                    [-30,  5, 10, 15, 15, 10,  5,-30],
                    [-40,-20,  0,  5,  5,  0,-20,-40],
                    [-50,-40,-30,-30,-30,-30,-40,-50]],
          Bishop => [[-20,-10,-10,-10,-10,-10,-10,-20],
                    [-10,  0,  0,  0,  0,  0,  0,-10],
                    [-10,  0,  5, 10, 10,  5,  0,-10],
                    [-10,  5,  5, 10, 10,  5,  5,-10],
                    [-10,  0, 10, 10, 10, 10,  0,-10],
                    [-10, 10, 10, 10, 10, 10, 10,-10],
                    [-10,  5,  0,  0,  0,  0,  5,-10],
                    [-20,-10,-10,-10,-10,-10,-10,-20]],
            Rook => [[0,  0,  0,  0,  0,  0,  0,  0],
                      [5, 10, 10, 10, 10, 10, 10,  5],
                     [-5,  0,  0,  0,  0,  0,  0, -5],
                     [-5,  0,  0,  0,  0,  0,  0, -5],
                     [-5,  0,  0,  0,  0,  0,  0, -5],
                     [-5,  0,  0,  0,  0,  0,  0, -5],
                     [-5,  0,  0,  0,  0,  0,  0, -5],
                    [0,  0,  0,  5,  5,  0,  0,  0]],
            Queen => [[-20,-10,-10, -5, -5,-10,-10,-20],
                      [-10,  0,  0,  0,  0,  0,  0,-10],
                      [-10,  0,  5,  5,  5,  5,  0,-10],
                       [-5,  0,  5,  5,  5,  5,  0, -5],
                        [0,  0,  5,  5,  5,  5,  0, -5],
                      [-10,  5,  5,  5,  5,  5,  0,-10],
                      [-10,  0,  5,  0,  0,  0,  0,-10],
                      [-20,-10,-10, -5, -5,-10,-10,-20]]
                  }

  BLACK_MOVE_TABLE = {  Pawn => [[900,  900,  900,  900,  900,  900,  900,  900],
                          [5, 10, 10,-20,-20, 10, 10,  5],
                          [5, -5,-10,  0,  0,-10, -5,  5],
                          [0,  0,  0, 20, 20,  0,  0,  0],
                          [5,  5, 10, 25, 25, 10,  5,  5],
                          [10, 10, 20, 30, 30, 20, 10, 10],
                          [50, 50, 50, 50, 50, 50, 50, 50],
                          [0,  0,  0,  0,  0,  0,  0,  0]],
                Knight => [[-50,-40,-30,-30,-30,-30,-40,-50],
                          [-40,-20,  0,  5,  5,  0,-20,-40],
                          [-30,  5, 10, 15, 15, 10,  5,-30],
                          [-30,  5, 15, 20, 20, 15,  5,-30],
                          [-30,  0, 15, 20, 20, 15,  0,-30],
                          [-30,  0, 10, 15, 15, 10,  0,-30],
                          [-40,-20,  0,  0,  0,  0,-20,-40],
                          [-50,-40,-30,-30,-30,-30,-40,-50]],
                Bishop => [[-20,-10,-10,-10,-10,-10,-10,-20],
                          [-10,  5,  0,  0,  0,  0,  5,-10],
                          [-10, 10, 10, 10, 10, 10, 10,-10],
                          [-10,  0, 10, 10, 10, 10,  0,-10],
                          [-10,  5,  5, 10, 10,  5,  5,-10],
                          [-10,  0,  5, 10, 10,  5,  0,-10],
                          [-10,  0,  0,  0,  0,  0,  0,-10],
                          [-20,-10,-10,-10,-10,-10,-10,-20]],
                  Rook => [[0,  0,  0,  5,  5,  0,  0,  0],
                          [-5,  0,  0,  0,  0,  0,  0, -5],
                          [-5,  0,  0,  0,  0,  0,  0, -5],
                          [-5,  0,  0,  0,  0,  0,  0, -5],
                          [-5,  0,  0,  0,  0,  0,  0, -5],
                          [-5,  0,  0,  0,  0,  0,  0, -5],
                          [5, 10, 10, 10, 10, 10, 10,  5],
                          [0,  0,  0,  0,  0,  0,  0,  0]],
                Queen => [[-20,-10,-10, -5, -5,-10,-10,-20],
                          [-10,  0,  5,  0,  0,  0,  0,-10],
                          [-10,  5,  5,  5,  5,  5,  0,-10],
                         [-5,  0,  5,  5,  5,  5,  0, -5],
                          [0,  0,  5,  5,  5,  5,  0, -5],
                          [-10,  0,  5,  5,  5,  5,  0,-10],
                          [-10,  0,  0,  0,  0,  0,  0,-10],
                          [-20,-10,-10, -5, -5,-10,-10,-20]]
                        }

    WHITE_KING_MIDDLE_GAME = [[-30,-40,-40,-50,-50,-40,-40,-30],
                              [-30,-40,-40,-50,-50,-40,-40,-30],
                              [-30,-40,-40,-50,-50,-40,-40,-30],
                              [-30,-40,-40,-50,-50,-40,-40,-30],
                              [-20,-30,-30,-40,-40,-30,-30,-20],
                              [-10,-20,-20,-20,-20,-20,-20,-10],
                               [20, 20,  0,  0,  0,  0, 20, 20],
                               [20, 30, 10,  0,  0, 10, 30, 20]]

     BLACK_KING_MIDDLE_GAME = [[20, 30, 10,  0,  0, 10, 30, 20],
                               [20, 20,  0,  0,  0,  0, 20, 20],
                               [-10,-20,-20,-20,-20,-20,-20,-10],
                               [-20,-30,-30,-40,-40,-30,-30,-20],
                               [-30,-40,-40,-50,-50,-40,-40,-30],
                               [-30,-40,-40,-50,-50,-40,-40,-30],
                               [-30,-40,-40,-50,-50,-40,-40,-30],
                               [-30,-40,-40,-50,-50,-40,-40,-30]]


    WHITE_KING_END_GAME = [[-50,-40,-30,-20,-20,-30,-40,-50],
                          [-30,-20,-10,  0,  0,-10,-20,-30],
                          [-30,-10, 20, 30, 30, 20,-10,-30],
                          [-30,-10, 30, 40, 40, 30,-10,-30],
                          [-30,-10, 30, 40, 40, 30,-10,-30],
                          [-30,-10, 20, 30, 30, 20,-10,-30],
                          [-30,-30,  0,  0,  0,  0,-30,-30],
                          [-50,-30,-30,-30,-30,-30,-30,-50]]

    BLACK_KING_END_GAME = [[-50,-30,-30,-30,-30,-30,-30,-50],
                          [-30,-30,  0,  0,  0,  0,-30,-30],
                          [-30,-10, 20, 30, 30, 20,-10,-30],
                          [-30,-10, 30, 40, 40, 30,-10,-30],
                          [-30,-10, 30, 40, 40, 30,-10,-30],
                          [-30,-10, 20, 30, 30, 20,-10,-30],
                          [-30,-20,-10,  0,  0,-10,-20,-30],
                          [-50,-40,-30,-20,-20,-30,-40,-50]]



  def initialize(name, game, color, board, display)
    @name = name
    @game = game
    @color = color
    @board = board
    @other_color = @color == :black ? :white : :black
    @display = display
  end

  def order_moves_by_value

  end

  attr_reader :move_count

  def play_turn(move_count)
    @move_count = move_count
    my_grid = @board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == @color }
    if move_count < 8
      all_moves = find_all_moves(pieces, @board).shuffle
    else
      all_moves = find_all_moves(pieces, @board)
    end
    system("clear")
    @display.render
    if move_count < 8
      move = calculate_best_move(all_moves, 1)
    else
      move = calculate_best_move(all_moves, 2)
    end
    return move
  end
  #
  # def capture?(start_pos, end_pos, board)
  #   return false if board[end_pos].color.nil? || board[end_pos].color == board[start_pos].color
  #   true
  # end
  #
  # def capture_moves(color)
  #
  # end

  def find_all_moves(pieces, board)
    moves = []
    if @move_count < 3
      pieces = pieces.shuffle
    else
      pieces = pieces.sort_by { |piece| PIECE_VALUES[piece.class]}.reverse
    end
    captures = []
    pieces.each do |piece|
      # captures << [piece.pos, piece.captu9r0e_moves]
      # moves << [piece.pos, piece.non_capture]
      moves << [piece.pos, piece.valid_moves]
    end
    # parsed_moves = moves.select { |move| move[1] != []}
    # p parsed_moves
    return moves
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
  #
  @board_hash_map = {}

  def calculate_best_move(moves, depth)
    isMax = true
    to_print = nil
    # checked = @board.in_check?(@color)
    # if checked
    #   moves = calculate_check_moves(moves, checked)
    # end
    best_value = -99999
    best_move = nil
    this = Time.now
    moves.each do |move_arr|
      start = move_arr[0]
      move_arr[1].each do |move|
        future = @board.deep_dup
        future.move_piece!(start, move)
        boardval = search_tree_for_move(depth, future, -100000, 100000, !isMax)
        # boardval = evaluate_board(future, @color)
        if (boardval > best_value )
          best_move = [start, move]
          best_value = boardval
          to_print = best_value
        end
        if (Time.now - this) > depth * 15
          p "this is the best move"
          p @color
          p best_value
         print Time.now - this
         @board_hash_map = {}
          return best_move
        end
      end
    end
     p "this is the best move"
     p @color
     p best_value
    print Time.now - this
    if best_value >= -99999 || best_value <= 99999
      @board_hash_map = {}
      return best_move
    else
      if pick_random_move(moves) == nil
        puts "checkmate"
        return nil
      else
        @board_hash_map = {}
        return pick_random_move(moves)
      end
    end

  end

  def no_children?(move_arr)
    move_arr.empty? || move_arr.nil? ? true : false
  end

  def search_tree_for_move(depth, board, alpha, beta, isMax)
    color = isMax == true ? @color : @other_color
    # color = isMax == true ? :black : :white
    if depth == 0
      return evaluate_board(board, color)
    end
    my_grid = board.grid
    pieces = my_grid.flatten.select { |piece| piece.color == color }
    moves = find_all_moves(pieces, board)
    if moves.empty?
      return evaluate_board(board, color)
    end
    if isMax
      best_move = -99999
      # pieces = board.grid.flatten.select { |piece| piece.color == @color }
      moves.each do |move_arr|
        # p move_arr
        if move_arr.empty?
          val = evaluate_board(board, color)
          best_move = best_move > val ? best_move : val
          next
        end
        start = move_arr[0]
        move_arr[1].each do |move|
          # future = board.dup
          future = board.deep_dup
          if @board_hash_map[future.grid]
            next
          else
            future.move_piece!(start, move)
            future_val = search_tree_for_move(depth - 1, future, alpha, beta, !isMax)
            best_move = best_move > future_val ? best_move : future_val
            # puts "\t" * depth + "black: " +  best_move.to_s
            alpha = [alpha, best_move].max
          end
          if beta <= alpha

            return best_move
          end
        end
      end
      return best_move
    else
      best_move = 99999
        moves.each do |move_arr|
          if move_arr.empty?
            val = evaluate_board(board, color)
            best_move = best_move < val ? best_move : val
            next
          end
          # return 9999 if no_children?(move_arr[1])
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
    acc = 0
    thisboard = future
    pieces.each do |el|
        if el.color == @color
          acc += PIECE_VALUES[el.class]
        else
          acc -= PIECE_VALUES[el.class]
        end
      if @move_count > 4
        if el.class != King
          # debugger
          if el.color == :white
            if el.color == @color
              acc += WHITE_MOVE_TABLE[el.class][el.pos[0]][el.pos[1]]
            else
              acc -= WHITE_MOVE_TABLE[el.class][el.pos[0]][el.pos[1]]
            end
          else
            if el.color == @color
              acc += BLACK_MOVE_TABLE[el.class][el.pos[0]][el.pos[1]]
            else
              acc -= BLACK_MOVE_TABLE[el.class][el.pos[0]][el.pos[1]]
            end
          end
        else
          if el.color == :white
            if el.color == @color
              if pieces.count > 12
                acc += WHITE_KING_MIDDLE_GAME[el.pos[0]][el.pos[1]]
              else
                acc += WHITE_KING_END_GAME[el.pos[0]][el.pos[1]]
              end
            else
              if pieces.count > 12
                acc -= WHITE_KING_MIDDLE_GAME[el.pos[0]][el.pos[1]]
              else
                acc -= WHITE_KING_END_GAME[el.pos[0]][el.pos[1]]
              end
            end
          else
            if el.color == @color
              if pieces.count > 12
                acc += BLACK_KING_MIDDLE_GAME[el.pos[0]][el.pos[1]]
              else
                acc += BLACK_KING_END_GAME[el.pos[0]][el.pos[1]]
              end
            else
              if pieces.count > 12
                acc -= BLACK_KING_MIDDLE_GAME[el.pos[0]][el.pos[1]]
              else
                acc -= BLACK_KING_END_GAME[el.pos[0]][el.pos[1]]
              end
            end
          end
        end
      end
    end

    # @board_hash_map[thisboard] = acc
    return acc
  end
end
