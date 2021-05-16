class Tile
    attr_reader :value
    def initialize(value=0)
        @value=value
        @value == 0 ? @given = false : @given = true
    end

    def to_s
        @value==0 ? " " : @value.to_s
    end

    def set_value(new_val)
        if (@given)
            puts "You can not set this tile"
            sleep(1)
        else
            @value=new_val
        end
    end
end