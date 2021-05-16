require_relative './human_player.rb'
require_relative './board.rb'

class Game
    def initialize(size, *player_marks)
        @num_players=player_marks.length
        @players=[]
        (0...@num_players).each do |i|
            @players << HumanPlayer.new(player_marks[i])
        end
        @b=Board.new(size)
        @current = @players[0]
    end
    def switch_turn
        @players.rotate!
        @current=@players[0]
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