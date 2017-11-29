require 'singleton'
require_relative 'board'
require_relative 'moves'

class Piece

  attr_reader :board, :color
  attr_accessor :pos
  def initialize(board, start_pos, color)
    @pos = start_pos
    @board = board
    @color = color
    @board[start_pos] = self
  end

  def dup(board)
    return self if self.class == NullPiece
    self.class.new(board, @pos, @color)
  end

  def move_into_check?(end_pos)#
    future = @board.deep_dup
    future.move_piece!(@pos, end_pos)
    future.in_check?(@color)
  end



  def to_s
    " #{@unicode} "
  end

  def inspect
    @name
  end

  def valid_move?(pos)
    Board.in_bounds?(pos) && @board[pos].color != self.color
  end

  def valid_moves
    self.moves.reject{ |move| self.move_into_check?(move) }
  end
end


class Rook < Piece
  include Slideable
  def initialize(board, start_pos, color)
    @name = 'r'
    @unicode = color == :black ? "\u265C" : "\u2656"
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
    @unicode = color == :black ? "\u265D" : "\u2657"
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
    @unicode = color == :black ? "\u265B" : "\u2655"
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
    @unicode = color == :black ? "\u265E" : "\u2658"

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
    @unicode = color == :black ? "\u265A" : "\u2654"
    super
    if color == :black
      @board.black_king_pos = start_pos
    else
      @board.white_king_pos = start_pos
    end
  end

  def move_type
    [:king]
  end

end

class Pawn < Piece
  include Steppable
  def initialize(board, start_pos, color)
    @name = 'p'
    @unicode = color == :black ? "\u265F" : "\u2659"

    super
  end

  def move_type
    [:pawn]
  end

end




class NullPiece < Piece
  include Singleton
  def initialize
    @unicode = " "
    @name = "_"
    @color = nil
  end

end
