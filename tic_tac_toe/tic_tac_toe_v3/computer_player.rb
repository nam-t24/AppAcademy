class ComputerPlayer
    attr_reader :mark
    def initialize(mark_)
        @mark=mark_
    end

    def get_position(valid_arr)
        position=valid_arr.sample
        p "Computer player chose position #{position} with mark #{@mark}"
        return position
    end
end