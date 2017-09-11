require_relative "board"
require_relative "cursor"
require "colorize"

class Display
  def initialize(board)
    @cursor = Cursor.new([0,0], board)
  end

  def render
    is_white = true
    background = nil
    @cursor.board.grid.each_with_index do |row, i|
      row.each_with_index do |square, j|
        if [i, j] == @cursor.cursor_pos
          if @cursor.selected
            background = :red
          else
            background = :blue
          end
        else
          background = is_white ? :white : :black
        end
        is_white = !is_white if j != 7
        print square.to_s.colorize(:background => background)
      end
      puts ""
    end
  end

    def render_loop
      while true
        render
        @cursor.get_input
        system("clear")
      end
    end


end

d = Display.new(Board.new)
d.render_loop
