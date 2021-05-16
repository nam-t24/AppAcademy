require_relative "board"
require_relative "player"

class Battleship
    attr_reader :board, :player
    def initialize(n)
        @player=Player.new
        @board=Board.new(n)
        @remaining_misses=@board.size/2
    end

    def start_game
        @board.place_random_ships
        puts @board.size*0.25
        @board.print
    end

    def lose?
        if(@remaining_misses<=0)
            puts "you lose"
            return true
        end
        false
    end
    def win?
        if @board.num_ships==0
            puts "you win"
            return true
        end
        false
    end
    def game_over?
        if self.lose? || self.win?
            return true
        end
        false
    end

    def turn
        input=@player.get_move
        success=@board.attack(input)
        if !success
            @remaining_misses-=1
        end
        puts @remaining_misses
        @board.print

    end

end
