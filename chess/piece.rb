require 'singleton'
require_relative 'board'
require 'byebug'
class Piece
  attr_reader :pos, :board, :color
  def initialize(board, start_pos, color)
    @pos = start_pos
    @board = board
    @color = color
  end

  def to_s
    @name
  end

  def inspect
    @name
  end
end

module Slideable

  def moves
    moves = []
    if self.move_dirs.include?(:diag)
      #diagonal moves can be (x-n, y-n), (x-n, y+n), (x+n, y-n), (x+n, y+n)

      [-1, 1].each do |dx|
        [-1, 1].each do |dy|
          x, y = @pos #reset start pos for each direction we check
          loop do
            x += dx
            y += dy
            pos = [x, y]
            break unless Board.in_bounds?(pos)
            break if @board[pos].color == self.color
            moves << [x, y]
          end
        end
      end
    end

    if self.move_dirs.include?(:hor_vert)


    end

    moves.uniq
  end

end

class Rook < Piece
  include Slideable
  def initialize(board, start_pos, color)
    @name = 'r'
    super
  end

  def move_dirs
    [:hor_vert]
  end

end

class Bishop < Piece
  include Slideable
  def initialize(board, start_pos, color)
    @name = 'b'
    super
  end

  def move_dirs
    [:diag]
  end
end

class Queen < Piece
  def initialize(board, start_pos, color)
    @name = 'Q'
    super
  end

  def move_dirs
    [:hor_vert, :diag]
  end

end


class NullPiece < Piece
  include Singleton
  def initialize
    @name = "  "
    @color = nil
  end

end
