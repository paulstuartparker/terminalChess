# terminalChess

Terminal Chess is a fully functional command line chess application written in Ruby.

Currently there is a functional AI implemented using the minimax algorithm and Alpha Beta pruning to speed up the recursive board evaluation function.  It is able to look ahead by three moves and takes roughly 8 seconds to do this calculation. The time it takes to make this calculation varies based on the number of moves available as well as what moves it evaluates first due to the nature of Alpha Beta pruning.


![terminal chess](giphy.gif)

#### The Computer Playing Against Itself!

To run the game clone this repository, navigate to the chess folder, and run the command 'ruby game.rb'.
It may be necessary to run the command 'gem install colorize' as well. 




