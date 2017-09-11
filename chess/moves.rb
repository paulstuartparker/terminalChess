module Steppable

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
        end
        x = @pos[0]
        loop do
          y += mvmt
          new_pos = [x, y]
          break unless self.valid_move?(new_pos)
          moves << new_pos
        end
      end
    end

    moves.uniq
  end

end