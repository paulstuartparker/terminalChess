require_relative "display"
require_relative "player"
require_relative "computer"

class ChessGame
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    # @player1 = HumanPlayer.new("Bobby Fischer", @display, :white)
    @player1 = ComputerPlayer.new("Bobby Fischer", self, :white, @board, @display)
    # @player2 = HumanPlayer.new("Garry Kasparov", @display, :black)
    @player2 = ComputerPlayer.new("Garry Kasparov", self, :black, @board, @display)

    @active_player = @player1
  end

  def play
    system("clear")
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      begin
        pos = @active_player.play_turn
        if pos.nil?
          print "checkmate" || pos.empty?
          break
        else
          start_pos, end_pos = pos[0], pos[1]
        end
        if @board[start_pos].color && @board[start_pos].color != @active_player.color
          raise InvalidMoveError.new("not your turn")
        end
        @board.move_piece(start_pos, end_pos)
        system "clear"
        @display.render
        if @board.checkmate?(:white) || @board.checkmate?(:black)
          print "checkmate!"
        end
      rescue InvalidMoveError => e
          puts e.message
          retry
      end

      @active_player = @active_player == @player1 ? @player2 : @player1
    end
  end

end

if $PROGRAM_NAME == __FILE__
  ChessGame.new.play
end
