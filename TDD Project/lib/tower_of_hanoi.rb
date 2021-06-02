require "byebug"
class Tower
    attr_reader :board, :winning_stick

    def initialize(board, stick)
        @board=board
        empty_sticks = []
        board.each_with_index {|sticks, idx| empty_sticks << idx if sticks.empty?}
        raise "Not a valid stick" unless empty_sticks.include?(stick)
        @winning_stick = stick
    end

    def play
        until won?
            system("clear")
            self.print_board
            self.move
        end
        self.print_board
        puts "you won!"
    end

    def won?
        return false if @board.count([]) != 2;
        @board.each_with_index do |stick, stick_idx|
            return false if (stick_idx==@winning_stick && stick.empty?);
        end
        true
    end

    def move
        puts "Enter start stick"
        start_stick=gets.chomp.to_i
        puts "Enter end stick"
        end_stick=gets.chomp.to_i

        if valid_move(start_stick, end_stick)
            make_move(start_stick, end_stick)
        else
            puts "Not a valid move"
            sleep(1)
        end

    end

    def make_move(start_stick, end_stick)
        @board[end_stick] << @board[start_stick].pop
    end

    def valid_move(start_stick, end_stick)
        return false if @board[start_stick].empty?
        return true if @board[end_stick].empty?;
        top_start = @board[start_stick][-1]
        top_end = @board[end_stick][-1]

        return top_start < top_end ? true : false;
    end

    def print_board
        (0...board.length).each do |row_idx|
            row=[]
            (0...board.length).each do |col_idx|
                if board[col_idx][board.length-1-row_idx] != nil
                    row << board[col_idx][board.length-1-row_idx].to_s
                else
                    row << "|"
                end
            end
            puts "#{row.join("  ")}"
        end
        puts "-------"
        puts "0  1  2"
    end
end

game =Tower.new([[3,2,1], [], []], 2)
game.play
