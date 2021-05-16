class HumanPlayer
    attr_reader :human
    def initialize(size)
        @human = true
    end
    def prompt
        puts "Enter a position(x,y)"
        position=gets.chomp
        [position[0].to_i, position[2].to_i]
    end
    def known_cards(pos, value)
        #empty, only for computer
    end
end