class Player
    attr_reader :name
    def initialize(name)
        @name=name
    end

    def guess(fragment)
        p "#{@name}, enter a letter to add to #{fragment}:"
        letter = gets.chomp.downcase
    end

    def alert_invalid_guess(letter)
        puts "#{letter} is not a valid move.\n"
    end
end