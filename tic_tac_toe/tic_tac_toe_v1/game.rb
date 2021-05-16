require_relative './human_player.rb'
require_relative './board.rb'

class Game
    def initialize(player_1_mark, player_2_mark)
        @player1=HumanPlayer.new(player_1_mark)
        @player2=HumanPlayer.new(player_2_mark)
        @b=Board.new
        @current = @player1
    end
    def switch_turn
        @current==@player1 ? @current = @player2 : @current=@player1
    end

    def play
        while(@b.empty_position?)
            @b.print
            position=@current.get_position
            @b.place_mark(position, @current.mark)
            if(@b.win?(@current.mark))
                @current==@player1 ? (p "Player 1 won!") : (p "Player 2 won!")
                return "Game Over"
            end
            self.switch_turn
        end
        p "draw"
    end

end