require_relative "display"
require_relative "moves"
class HumanPlayer
  attr_reader :name, :color
  def initialize(name, display, color)
    @name = name
    @display = display
    @color = color
  end

  def play_turn(move_count)
    move = []
    loop do
      puts "#{@color.to_s}'s turn"
      @display.render
      cur_in = @display.cursor.get_input
      system("clear")
      unless cur_in.nil?
        move << cur_in
      end
      return move if move.size == 2
    end

  end


end
