require 'set'
require_relative './Player.rb'

class Game
    LETTERS = ("a".."z").to_a
    MAX_LOSSES=5
    attr_reader :dictionary
    def initialize(*players)
        words= File.read("dictionary.txt").split
        @players=players
        @dictionary= Set.new(words)
        @losses = {}
        @players.each do |player|
            @losses[player]=0
        end
    end

    def run
        while(!game_over?)
            self.play_round
        end
        p "#{current_player.name} won the GAME!"
    end

    def game_over?
        count=0
        @losses.each_value {|value| count+=1 if value==MAX_LOSSES}
        (count == @players.length-1) ? (return true) : (return false)
    end

    def play_round
        @fragment=""
        while (!valid_fragment?(@fragment))
            take_turns(current_player)
            next_player!
        end
        p "#{@fragment} is a word!"
        p "#{previous_player.name} lost the round!"
        @losses[previous_player]+=1
        self.display_standings

    end

    #helper methods
    def current_player
        @players[0]
    end

    def previous_player
        (0...@players.length).reverse_each do |i|
            if @losses[@players[i]]< MAX_LOSSES
                return @players[i]
            end
        end
    end

    def next_player!
        @players.rotate!
        while(@losses[current_player] == MAX_LOSSES)
            @players.rotate!
        end
    end

    def take_turns(player)
        letter = player.guess(@fragment)
        while(!self.valid_play?(letter))
            player.alert_invalid_guess(letter)
            letter = player.guess(@fragment)
        end

        @fragment+=letter
    end

    def valid_play?(str)
        return false if !LETTERS.include?(str)
        dictionary.any? { |word| word.start_with?(@fragment+str) }
    end

    def valid_fragment?(fragment)
        dictionary.include? fragment
    end
    
    def display_standings
        puts "\nCurrent Standing\n----------"
        @losses.each do |player, value|
            p "#{player.name}".ljust(10) + "| #{value}"
        end
        puts "-----------\n"
    end
end

game = Game.new(
    Player.new("Gizmo"), 
    Player.new("Breakfast"), 
    Player.new("Toby"),
    Player.new("Leonardo")
    )
game.run