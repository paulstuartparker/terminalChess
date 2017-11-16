require_relative "board"
require_relative "cursor"
require "colorize"

class Display
  attr_reader :cursor
  def initialize(board, start_pos=[6,4])
    @cursor = Cursor.new(start_pos, board)
  end

  def render
    is_white = true
    background = nil
    puts "    a  b  c  d  e  f  g  h \n"

    @cursor.board.grid.each_with_index do |row, i|
      print "#{8 - i}  "
      row.each_with_index do |square, j|
        if [i, j] == @cursor.cursor_pos
          if @cursor.selected
            background = :red
          else
            background = :blue
          end
        else
          background = is_white ? :whitesmoke : :cyan
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
        puts @cursor.get_input
        system("clear")
      end
    end


end
