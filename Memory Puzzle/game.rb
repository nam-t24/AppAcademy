require_relative './board.rb'
require_relative './HumanPlayer.rb'
require_relative './ComputerPlayer.rb'

class Game
    def initialize(player, size)
        @board = Board.new(size)
        @previous_guess=[]
        @player = player
    end

    def play
        @board.render
        until @board.won?
            @board.render
            pos=@player.prompt
            self.make_guess(pos)
        end
        @board.render
        puts "Won!"
    end

    def make_guess(pos)
        #first guess
        if @previous_guess.length==0
            if(@board[pos].is_revealed)
                puts "Already revealed"
                sleep(1)
            else
                #non revealed posision
                value=@board.reveal(pos)
                @previous_guess=pos
                @player.known_cards(@previous_guess, value)
                if @player.human==false
                    @player.previous_guess=pos
                end
            end
        #second guess
        else
            if(@board[pos].is_revealed)
                puts "Already revealed"
                sleep(1)
            else
                #non revealed posision
                if @board[pos] == @board[@previous_guess]
                    @board.reveal(pos)
                    #for computer player
                    if @player.human==false
                        @player.matched_cards(pos)
                        @player.matched_cards(@previous_guess)
                    end
                else
                    value = @board.reveal(pos)
                    @player.known_cards(pos, value)
                    @board.render
                    puts "Nice try but wrong"
                    sleep(2)

                    @board.hide(pos)
                    @board.hide(@previous_guess)
                end
                @previous_guess=[]
                #for computer player
                if @player.human==false
                    @player.previous_guess=[]
                end
            end
        end
    end
end

if $PROGRAM_NAME == __FILE__
  size = ARGV.empty? ? 4 : ARGV.shift.to_i
  Game.new(ComputerPlayer.new(size), size).play
#   Game.new(HumanPlayer.new(size), size).play
end