require_relative "display"
require_relative "player"
require_relative "computer"

class ChessGame
  def initialize
    system "clear"
    @board = Board.new
    # @display = Display.new(@board)
    determine_players
    # @player1 = HumanPlayer.new("Bobby Fischer", @display, :white)
    # @player1 = ComputerPlayer.new("Bobby Fischer", self, :white, @board, @display)
    # # @player2 = HumanPlayer.new("Garry Kasparov", @display, :black)
    # @player2 = ComputerPlayer.new("Garry Kasparov", self, :black, @board, @display)
    @active_player = @player1
    @game_state = {
      boards: [],
      fourfold: 1,
      insufficient_material: false
    }
    @game_state[:boards].push(@board.deep_dup)
  end

  def determine_players
    puts "Welcome to terminalChess"
    puts "Enter 1 for computer vs computer"
    puts "Enter 2 for human vs computer"
    puts "Enter 3 for human vs human"
    choice = gets.chomp
    if choice.to_i == 1 || choice.to_i == 2
      howsmart = determine_intelligence
    end
    initialize_display(choice)
    initialize_players(choice, howsmart)
  end

  def determine_intelligence
    system "clear"
    puts "How smart would you like the computer to be?"
    puts "Enter 1 for NOT SMART"
    puts "Enter 2 for Sort of Smart(recommended)"
    puts "Enter 3 for Smarter(Slower, 5-15 seconds / move depending on board position)"
    puts "Enter 4 for Smart(Slow!, 12-25+ seconds / move depending on board position - This is Ruby, not C++!)"
    return gets.chomp.to_i
  end

  def initialize_display(choice)
    if choice.to_i == 1
      @display = Display.new(@board, :white)
    else
      @display = Display.new(@board, :blue)
    end
  end

  def initialize_players(choice, how_smart)
    case choice.to_i
    when 1
      @player1 = ComputerPlayer.new("Bobby Fischer", self, :white, @board, @display, how_smart - 1)
      @player2 = ComputerPlayer.new("Garry Kasparov", self, :black, @board, @display, how_smart - 1)
    when 2
      @player1 = HumanPlayer.new("Bobby Fischer", @display, :white)
      @player2 = ComputerPlayer.new("Garry Kasparov", self, :black, @board, @display, how_smart - 1)
    when 3
      @player1 = HumanPlayer.new("Bobby Fischer", @display, :white)
      @player2 = HumanPlayer.new("Garry Kasparov", @display, :black)
    else
      determine_players
    end
  end

  def play
    system("clear")
    if @active_player.class == ComputerPlayer
      @display.render
    end
    until @board.checkmate?(:white) || @board.checkmate?(:black) || self.draw?
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
        update_state(@board)
        system "clear"
        if @player1.class == ComputerPlayer
          @display.render
        end

        if @board.checkmate?(:white) || @board.checkmate?(:black)
          puts "checkmate! #{@active_player.color} wins!"
        end

        if self.draw?
          puts "draw :-|"
        end

      rescue InvalidMoveError => e
          puts e.message
          retry
      end
      @active_player = @active_player == @player1 ? @player2 : @player1
    end
  end

  def draw?
    if @game_state[:fourfold] > 4 || @game_state[:insufficient_material]
      return true
    end
    false
  end

  def update_state(board)
    @game_state[:fourfold] = 1
    current_board = Marshal.load(Marshal.dump(board))

    @game_state[:boards].each do |game_board|
      if game_board.inspect == board.inspect
        @game_state[:fourfold] += 1
      end
    end

    @game_state[:boards].push(current_board)

    if current_board.grid.count < 4
      @game_state[:insufficient_material] = true
    end
  end

end

if $PROGRAM_NAME == __FILE__
  ChessGame.new.play
end
