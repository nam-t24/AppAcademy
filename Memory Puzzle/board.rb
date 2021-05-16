require_relative './card.rb'
require "byebug"
class Board

    def [](pos)
        row, col = pos
        @grid[row][col]
    end

    def []=(pos, value)
        row, col = pos
        @grid[row][col] = value
    end

    def initialize(size=4)
        @grid = Array.new(size){Array.new(size)}
        @size=size
        populate
    end

    def populate
        pairs= (@size**2)/2
        cards =Card.get_pairs(pairs)
        @grid.each_index do |i|
            @grid[i].each_index do |j|
                self[[i,j]]=cards.pop
            end
        end
    end

    def render
        system("clear")
        puts "  #{(0...@size).to_a.join(' ')}"
        @grid.each_with_index do |row, i|
          puts "#{i} #{row.join(' ')}"
        end
    end

    def won?
        @grid.all? do |row|
            row.all? {|ele| ele.is_revealed}
        end
    end

    def is_revealed(pos)
        self[pos].is_revealed
    end

    def hide(pos)
        self[pos].hide
    end

    def reveal(pos)
        if self[pos].is_revealed
            puts "Already revealed"
            sleep(2)
        else
            self[pos].reveal
        end
        return self[pos].face_value
    end
end