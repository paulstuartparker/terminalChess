# terminalChess

Terminal Chess is a fully functional command line chess application written in Ruby.
The game logic is implemented using two modules: slideable and steppable, which extened the piece classes. 

[terminal chess](https://github.com/paulstuartparker/terminalChess/blob/master/Screen%20Shot%202017-11-07%20at%2011.03.40%20PM.png)

Currently there is a very weak AI implemented which will take the most valuable piece available to it at any given time,
and it will also move out of check when threatened.  
This is accomplished by implementing a piece points system which calculates the best move at any given time based on the 
value of the board (positive or negative) at any given time.  
I am currently working on implementing the minimax algorithm and using alpha
beta pruning to speed up the time it takes to calculate the move tree.  
I was able to get a rudimentary version working but it was EXTREMELY slow and is now living in another until I can make it better.


