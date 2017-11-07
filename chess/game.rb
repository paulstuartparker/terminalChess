require_relative "display"
require_relative "player"

class ChessGame
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @player1 = HumanPlayer.new("Bobby Fischer", @display, :white)
    @player2 = HumanPlayer.new("Garry Kasparov", @display, :black)
    @active_player = @player1
  end

  def play
    system("clear")
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      begin
        start_pos, end_pos = @active_player.play_turn
        if @board[start_pos].color && @board[start_pos].color != @active_player.color
          raise InvalidMoveError.new("not your turn")
        end
        @board.move_piece(start_pos, end_pos)
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
