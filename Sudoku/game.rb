require_relative './board.rb'

class Game
    def initialize(file)
        @board= Board.new(Board.from_file(file))
    end

    def play
        @board.render
        until @board.solved?
            system("clear")
            @board.render
            puts "Enter position: row,col"
            position = gets.chomp
            pos=[position[0].to_i,position[2].to_i]
            puts "Enter a value"
            value= gets.chomp.to_i
            @board[pos].set_value(value)
        end
        puts "You won!"
    end
end

if $PROGRAM_NAME == __FILE__
    file = size = ARGV.empty? ? "sudoku1_solved.txt" : ARGV.shift
    Game.new(file).play
end