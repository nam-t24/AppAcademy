require_relative './human_player.rb'
require_relative './board.rb'
require_relative './computer_player.rb'

class Game
    def initialize(size, player_hash)
        #mark , false/true
        @players=[]
        player_hash.each do |key, value|
            value ? @players << ComputerPlayer.new(key) : @players << HumanPlayer.new(key)
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
            position=@current.get_position(@b.legal_positions)
            @b.place_mark(position, @current.mark)
            if(@b.win?(@current.mark))
                p "Player with #{@current.mark} won"
                return "Game Over"
            end
            self.switch_turn
        end
        p "draw"
    end

end