class InvalidMoveError < StandardError
end

require_relative "piece"

class Board
  attr_reader :grid
  attr_accessor :black_king_pos, :white_king_pos
  def initialize(empty = false)
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
    unless empty
      set_rooks
      set_knights
      set_bishops
      set_royalty
      set_pawns
    end
  end

  def deep_dup
    new_board = Board.new(true)
    @grid.each do |row|
      row.each do |piece|
        next if piece.class == NullPiece
        piece.dup(new_board)
      end
    end
    new_board
  end


    def dup
      # new_board = Board.new
      # grid = []
      # 0.upto(7) do |row|
      #   sub_arr = []
      #   0.upto(7) do |col|
      #     if self[[row, col]].is_a? NullPiece
      #       sub_arr << NullPiece.instance
      #     else
      #       #
      #       piece = self[[row, col]]
      #       piece_class = piece.class
      #       new_piece = piece_class.new(piece.board, piece.pos, piece.color)
      #       # new_piece.color = piece.color
      #       # new_piece.pos = [row, col]
      #       # new_piece.board = new_board
      #       sub_arr << new_piece
      #     end
      #   end
      #   grid << sub_arr
      # end
      # new_board.grid = grid
      # new_board
      new_board = Marshal.load(Marshal.dump(self))
    end



  def set_rooks
    Rook.new(self, [0,0], :black)
    Rook.new(self, [0,7], :black)
    Rook.new(self, [7,0], :white)
    Rook.new(self, [7,7], :white)
  end

  def set_knights
    Knight.new(self, [0,1], :black)
    Knight.new(self, [0,6], :black)
    Knight.new(self, [7,1], :white)
    Knight.new(self, [7,6], :white)
  end

  def set_bishops
    Bishop.new(self, [0,2], :black)
    Bishop.new(self, [0,5], :black)
    Bishop.new(self, [7,2], :white)
    Bishop.new(self, [7,5], :white)
  end

  def set_royalty
    Queen.new(self, [0,3], :black)
    King.new(self, [0,4], :black)
    Queen.new(self, [7,3], :white)
    King.new(self, [7,4], :white)
    @black_king_pos = [0, 4]
    @white_king_pos = [7, 4]
  end

  def set_pawns
    (0..7).each do |i|
      Pawn.new(self, [1, i], :black)
      Pawn.new(self, [6, i], :white)
    end
  end

  def in_check?(color)
    king_pos = color == :black ? @black_king_pos : @white_king_pos
    @grid.any? do |rows|
      rows.any? do |piece|
        next if piece.class == NullPiece || piece.moves.empty?
        if piece.moves.include?(king_pos)
          return piece.pos
        end
      end
    end
    false
  end

  def checkmate?(color)
    my_pieces = @grid.flatten.select { |piece| piece.color == color }
    self.in_check?(color) && my_pieces.all? { |piece| piece.valid_moves.empty? }
  end



  def move_piece(start_pos, end_pos)
    #
    null = NullPiece.instance
    raise InvalidMoveError.new("nothing to move") if self[start_pos].class == NullPiece
    #
    raise InvalidMoveError.new("start and end are the same") if start_pos == end_pos
    raise InvalidMoveError.new("illegal move") unless self[start_pos].valid_moves.include?(end_pos)
    raise InvalidMoveError.new("would move into check") if self[start_pos].move_into_check?(end_pos)
    #TODO once we have pieces implemented: check if move valid
    # if board[end_pos] is invalid
    #   raise InvalidMoveError("")
    # end
    self.move_piece!(start_pos, end_pos)

  end

#move piece without checking if move is valid
  # def move_piece!(start_pos, end_pos)
  #   null = NullPiece.instance
  #   #
  #   if self[start_pos].class == King
  #     if self[start_pos].color == :black
  #       @black_king_pos = end_pos
  #     else
  #       @white_king_pos = end_pos
  #     end
  #   end
  #   self[start_pos].pos = end_pos
  #   self[end_pos], self[start_pos] = self[start_pos], null
  # end

  def move_piece!(start_pos, end_pos)
    null = NullPiece.instance
    #
    if self[start_pos].class == King
      if self[start_pos].color == :black
        @black_king_pos = end_pos
      else
        @white_king_pos = end_pos
      end
    end
    if pawn_promotion?(start_pos, end_pos)
      color = self[start_pos].color
      self[start_pos] = null
      Queen.new(self, end_pos, color)
    else
      self[start_pos].pos = end_pos
      self[end_pos], self[start_pos] = self[start_pos], null
    end
  end
  
  def []=(pos, piece)
    x, y = pos
    #TODO: check if theres a piece here and raise accordingly
    @grid[x][y] = piece
  end

  def [](pos)
    if pos.nil? || pos.empty?
      p pos
      print "nil bug"
      return nil
    end
    x, y = pos

    if @grid.nil? || (x.nil? || y.nil?)
      print "nil"
      return nil
    end
    @grid[x][y]
  end

  def self.in_bounds?(pos)
    x, y = pos
    x < 8 && y < 8 && x >= 0 && y >= 0
  end

  def inspect
    b_str = "\n  a  b  c  d  e  f  g  h \n"
    @grid.each_with_index do |row, i|
      b_str += "#{8 - i} "
      row.each do |piece|
        b_str += "#{piece.inspect}  "
      end
      b_str += "\n"
    end
    b_str

  end
  def pawn_promotion?(start_pos, end_pos)
    if end_pos[0] == 0 || end_pos[0] == 7
      if self[start_pos].class == Pawn
        return true
      end
    end
  false
  end


end
