require "byebug"
class Board
    attr_reader :size
    def initialize(n)
        @grid=Array.new(n){Array.new(n,:N)}
        @size=n*n
    end
  
    def [](array)
        @grid[array[0]][array[1]]
    end

    def []=(position, value)
        @grid[position[0]][position[1]]=value
    end

    def num_ships()
        count=0
        @grid.each do |row|
            count+=row.count(:S)
        end
        count
    end

    def attack(position)
        if self[position]==:S
            self[position]=:H
            puts "you sunk my battleship!"
            return true
        else
            self[position]=:X
            return false
        end
    end

    def place_random_ships
        total=@size*0.25
        count=0
        while(count<total)
            arr=[rand(0...@grid.length),rand(0...@grid.length)]
            if self[arr]!= :S
                self[arr]= :S
                count+=1
            end
        end
    end
    def hidden_ships_grid
        @grid.map do |row|
            row.map do |ele| 
                if ele==:S
                    :N
                else
                    ele
                end
            end
        end
    end

    def self.print_grid(grid_arg)
        grid_arg.each do |row|
            (0...row.length).each do |i|
                print row[i].to_s
                print " " if i!=row.length-1
            end
            puts
        end
    end
    def cheat
        Board.print_grid(@grid)
    end
    def print
        Board.print_grid(self.hidden_ships_grid)
    end

end
