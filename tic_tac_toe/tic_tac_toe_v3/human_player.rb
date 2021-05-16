class HumanPlayer
    attr_reader :mark
    def initialize(mark_)
        @mark=mark_
    end

    def get_position(legal_positions)
        p "Enter position"
        position_str=gets.chomp.split(" ")
        #raise "need 2 positions" if position_str.length !=2
        position_int = position_str.map {|ele| ele.to_i}
        while !legal_positions.include? position_int
            p "Illegal Position"
            p "Enter position"
            position_str=gets.chomp.split(" ")
            position_int = position_str.map {|ele| ele.to_i}
        end
        position_int
    end
end
