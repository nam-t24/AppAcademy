class ComputerPlayer
    def matched_cards(pos)
        @matched_cards << pos
    end
    attr_reader :human
    attr_writer :previous_guess
    def initialize(size)
        @board_size=size
        @matched_cards = []
        @known_cards = {}
        @previous_guess=[]
        @human=false
        @previous_value
    end

    def prompt
        puts "Enter a position(x,y)"
        #first guess
        if(@previous_guess==[])
            self.get_random
        #second guess
        else
            self.get_card
        end
    end

    def get_random
        rows=(0...@board_size).to_a
        col = (0...@board_size).to_a
        pos = [rows.sample, col.sample]
        
        until ((!@matched_cards.include? pos) && pos != @previous_guess)
            rows=(0...@board_size).to_a
            col = (0...@board_size).to_a
            pos = [rows.sample, col.sample]
        end
        pos
    end

    def get_card
        positions=[]
        if (@known_cards.has_value?(@previous_value))
            positions = self.get_known_positions
            return positions if positions!=[]
        end
        self.get_random
    end

    def get_known_positions
        positions=[]
        @known_cards.each do |position, value|
            positions = position if (value == @previous_value && position!=@previous_guess)
        end
        positions
    end

    def known_cards(pos, value)
        @known_cards[pos] = value
        @previous_value = value if @previous_guess == []
    end
end