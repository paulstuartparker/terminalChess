require_relative "piece"

class Board
  attr_reader :grid
  def initialize
    @grid = Array.new(8) { Array.new(8) { NullPiece.instance } }
  end

  class InvalidMoveError < StandardError
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


end
