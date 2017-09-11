require 'singleton'
require_relative 'board'
require_relative 'moves'
require 'byebug'
class Piece
  attr_reader :board, :color
  attr_accessor :pos
  def initialize(board, start_pos, color)
    @pos = start_pos
    @board = board
    @color = color
    @board[start_pos] = self
  end

  def to_s
    @name
  end

  def inspect
    @name
  end

  def valid_move?(pos)
    Board.in_bounds?(pos) && @board[pos].color != self.color
  end
end


class Rook < Piece
  include Slideable
  def initialize(board, start_pos, color)
    @name = 'r'
    super
  end

  def move_type
    [:hor_vert]
  end

end

class Bishop < Piece
  include Slideable
  def initialize(board, start_pos, color)
    @name = 'b'
    super
  end

  def move_type
    [:diag]
  end
end

class Queen < Piece
  include Slideable
  def initialize(board, start_pos, color)
    @name = 'Q'
    super
  end

  def move_type
    [:hor_vert, :diag]
  end

end

class Knight < Piece
  include Steppable
  def initialize(board, start_pos, color)
    @name = 'n'
    super
  end

  def move_type
    [:knight]
  end
end

class King < Piece
  include Steppable
  def initialize(board, start_pos, color)
    @name = 'K'
    super
  end

  def move_type
    [:king]
  end

end

class Pawn < Piece
  include Steppable
  def initialize(board, start_pos, color)
    @name = 'p'
    super
  end

  def move_type
    [:pawn]
  end
end




class NullPiece < Piece
  include Singleton
  def initialize
    @name = "  "
    @color = nil
  end

end
