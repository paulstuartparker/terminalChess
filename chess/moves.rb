
module Steppable
  def moves

    if self.move_type.include?(:knight)
      x, y = pos
      arr = [-2,-1,1,2]
      movements = arr.product(arr).reject { |a, b| a.abs == b.abs }
      moves = movements.map { |a, b| [x+a, y+b] }

      return moves.select { |move| self.valid_move?(move) }
    end

    if self.move_type.include?(:king)
      x, y = pos
      arr = [-1, 0, 1]
      movements = arr.product(arr)
      moves = movements.map { |a, b| [x+a, y+b] }
      return moves.select { |move| self.valid_move?(move) }
    end

    if self.move_type.include?(:pawn)

      x, y = pos
      direction = self.color == :black ? 1 : -1
      new_x = x + direction
      new_x = new_x > 7 ? x : new_x
      new_pos = [new_x, y]

      if @board[new_pos].color.nil?
        moves = [new_pos]
      else
        moves = []
      end
      #check diagonals for capturable
      [-1, 1].each do |dy|
        new_pos = [new_x, (y + dy)]
        if new_pos.any? { |n| n < 0 || n > 7}
          next
        end
        unless @board[new_pos].color.nil?
          moves << new_pos
        end
      end
      if x == 1 && self.color == :black
        plus_one = new_x
        new_x += direction
        newmove = [new_x, y]
        moves << [new_x, y] if @board[newmove].color.nil? && moves.include?([plus_one, y])
      elsif x == 6 && self.color == :white
        plus_one = new_x
        new_x += direction
        newmove = [new_x, y]
        moves << [new_x, y] if @board[newmove].color.nil? && moves.include?([plus_one, y])
      end

      if self.color == :black && x == 6

        [-1, 1].each do |dy|
          new_y = y + dy
          newpos = [7, dy]
          if @board[newpos].color == :white
            moves << newpos
          end
        end
      end


      moves = moves.select { |move| self.valid_move?(move)}
    end




  end


end

module Slideable

  def moves
    moves = []
    if self.move_type.include?(:diag)
      #diagonal moves can be (x-n, y-n), (x-n, y+n), (x+n, y-n), (x+n, y+n)

      [-1, 1].each do |dx|
        [-1, 1].each do |dy|
          x, y = @pos #reset start pos for each direction we check
          loop do
            x += dx
            y += dy
            new_pos = [x, y]
            break unless self.valid_move?(new_pos)
            moves << [x, y]
            break unless self.board[new_pos].class == NullPiece
          end
        end
      end
    end

    if self.move_type.include?(:hor_vert)
      [1, -1].each do |mvmt|
        x, y = @pos
        loop do
          x += mvmt
          new_pos = [x, y]
          break unless self.valid_move?(new_pos)
          moves << new_pos
          break unless self.board[new_pos].class == NullPiece
        end
        x = @pos[0]
        loop do
          y += mvmt
          new_pos = [x, y]
          break unless self.valid_move?(new_pos)
          moves << new_pos
          break unless self.board[new_pos].class == NullPiece
        end
      end
    end

    moves.uniq
  end

end
