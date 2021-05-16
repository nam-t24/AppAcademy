class HumanPlayer
    attr_reader :mark
    def initialize(mark_)
        @mark=mark_
    end

    def get_position
        p "Enter position"
        position_str=gets.chomp.split(" ")
        raise "need 2 positions" if position_str.length !=2
        position_str.map {|ele| ele.to_i}
    end
end
