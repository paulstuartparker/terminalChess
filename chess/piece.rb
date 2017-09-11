require 'singleton'
class Piece
  def initialize
    @name = "p"
  end

  def to_s
    @name
  end

  def inspect
    @name
  end
end

class NullPiece < Piece
  include Singleton
  def initialize
    @name = "  "
  end

end
