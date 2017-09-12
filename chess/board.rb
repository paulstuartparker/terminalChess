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

  def dup
    new_board = Board.new(true)
    @grid.each do |row|
      row.each do |piece|
        next if piece.class == NullPiece
        piece.dup(new_board)
      end
    end
    new_board
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
        next if piece.class == NullPiece
        piece.moves.include?(king_pos)
      end
    end
  end

  def checkmate?(color)

  end



  def move_piece(start_pos, end_pos)
    null = NullPiece.instance
    raise InvalidMoveError.new("nothing to move") if self[start_pos].class == NullPiece
    raise InvalidMoveError.new("start and end are the same") if start_pos == end_pos
    raise InvalidMoveError.new("illegal move") unless self[start_pos].moves.include?(end_pos)
    #TODO once we have pieces implemented: check if move valid
    # if board[end_pos] is invalid
    #   raise InvalidMoveError("")
    # end
    if self[start_pos].class == King
      if self[start_pos].color == :black
        @black_king_pos = end_pos
      else
        @white_king_pos = end_pos
      end
    end
    self[start_pos].pos = end_pos
    self[end_pos], self[start_pos] = self[start_pos], null

  end



  def []=(pos, piece)
    x, y = pos
    #TODO: check if theres a piece here and raise accordingly
    @grid[x][y] = piece
  end

  def [](pos)
    x, y = pos
    @grid[x][y]
  end

  def self.in_bounds?(pos)
    x, y = pos
    x < 8 && y < 8 && x >= 0 && y >= 0
  end

  def inspect
    b_str = "\n"
    @grid.each do |row|
      row.each do |piece|
        b_str += "#{piece.to_s} "
      end
      b_str += "\n"
    end
    b_str

  end



end
