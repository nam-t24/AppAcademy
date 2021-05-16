class Board
    def initialize
        @grid= Array.new(3) {Array.new(3,'_')}
    end

    def valid?(position)
        position.all? {|ele| ele>=0 && ele<=2}
    end

    def empty?(position)
        @grid[position[0]][position[1]] =='_'
    end

    def place_mark(position, mark)
        if (valid?(position) && empty?(position))
            @grid[position[0]][position[1]]=mark
        else
            raise "Error: not valid position"
        end
    end

    def print
        p @grid[0]
        p @grid[1]
        p @grid[2]
    end

    def win_row?(mark)
        @grid.any? do |row|
            row.all? {|ele| ele==mark}
        end
    end

    def win_col?(mark)
        (0..2).each do |i|
            count=0
            (0..2).each do |j|
                if(@grid[j][i]==mark)
                    count+=1
                end
            end
            return true if count==3
        end
        false
    end
    def win_diagonal?(mark)
        length=@grid.length
        (0..2).each do |i|
            if(@grid[i][i]!=mark && @grid[length-i-1][i]!=mark)
                return false
            end
        end
        true
    end

    def win?(mark)
        (win_row?(mark) || win_col?(mark) || win_diagonal?(mark)) ? true : false
    end

    def empty_position?
        @grid.each do |row|
            row.each do |ele|
                return true if ele=='_'
            end
        end
        false
    end
end



