require "byebug"
require_relative './tile.rb'
class Board
    def initialize(grid)
        @grid=grid
    end

    def render
        puts "  #{(0...9).to_a.join(' ')}"
        @grid.each_with_index do |row, i|
            join_row = "#{row.join(' ')}".split("")
            join_row.map!.with_index do |char, i|
                if i==5 || i==11
                    '|'
                else
                    char
                end

            end
            puts "#{i} #{join_row.join("")}"
            puts "  -----+-----+-----" if (i+1)%3 == 0 && i+1 != @grid.length
        end
    end

    def [](pos)
        @grid[pos[0]][pos[1]]
    end

    def self.from_file(file)
        arr=[]
        File.foreach(file) { |line| arr << line.chomp}
        arr.map! do |line|
            line_arr=line.split("")
            line_arr.map! {|num| Tile.new(num.to_i)}
        end
        arr
    end

    #solved methods
    def solved?
        rows_solved? && col_solved? && box_solved?
    end

    def rows_solved?
        @grid.each do |row|
            values = (1..9).to_a
            row.each do |tile|
                if values.include? tile.value
                    values.delete(tile.value)
                else
                    return false
                end
            end
        end
        return true
    end

    def col_solved?
        @grid.each_with_index do |row, row_index|
            values = (1..9).to_a
            row.each_with_index do |col, col_index|
                pos=[col_index, row_index]
                if values.include? self[pos].value
                    values.delete(self[pos].value)
                else
                    return false
                end
            end
        end
        return true
    end

    def box_solved?
        box=[]
        row=0
        col=0
        while(row<9)
            col=0
            while(col<9)
                box_row = row
                rowNum = box_row
                box=[]
                while(box_row < rowNum +3)
                    box_col = col
                    colNum=box_col
                    while(box_col < colNum +3)
                        pos=[box_row, box_col]
                        # debugger
                        box << self[pos].value
                        box_col+=1
                    end
                    box_row+=1
                end
                return false if check_box(box) == false
                col+=3
            end
            row+=3
        end
        true
    end

    def check_box(box)
        #box is a 1d array
        values = (1..9).to_a
        box.each do |value|
            values.delete(value) if values.include? value
        end
        values==[]
    end
end

# board = Board.new(Board.from_file("sudoku1.txt"))
# board = Board.new(Board.from_file("sudoku1_solved.txt"))
# board.render
# p board.solved?