class Card
    VALUES = ("A".."Z").to_a
    attr_reader :face_down, :face_value
    def initialize(face)
        @face_value = face
        @face_down = true
    end

    def self.get_pairs(pairs)
        values= VALUES
        while pairs > values.length
            values = values + values
        end

        values = values.shuffle.take(pairs) * 2
        values.shuffle!
        values.map { |val| self.new(val) }
    end

    def display_info
        return nil if @face_down
        return @face_value
    end

    def hide
        @face_down = true
    end

    def reveal
        @face_down = false
    end

    def to_s
        @face_down==false ? @face_value.to_s : " "
    end

    def ==(card)
        return true if self.face_value == card.face_value
    end

    def is_revealed
        @face_down ? (return false) : (return true)
    end
end