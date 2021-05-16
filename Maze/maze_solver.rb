require "byebug"
class Maze
    attr_reader :end_index, :start_index, :current

    def initialize(file_name)
        @maze=read_maze(file_name)
        @start_index=find_index('S')
        @end_index=find_index('E')
        @current_index=@start_index
    end

    def run
        self.print_maze
        puts "\n"
        count=0
        until @maze[@current_index[0]][@current_index[1]] == 'E'
            if(self.move_up?)
                # debugger
                @current_index[0]-=1
                @maze[@current_index[0]][@current_index[1]] = 'S' if @maze[@current_index[0]][@current_index[1]]!='E'
            elsif(self.move_right?)
                @current_index[1]+=1
                @maze[@current_index[0]][@current_index[1]] = 'S' if @maze[@current_index[0]][@current_index[1]]!='E'
            elsif(self.move_down?)
                @current_index[0]+=1
                @maze[@current_index[0]][@current_index[1]] = 'S' if @maze[@current_index[0]][@current_index[1]]!='E'
            elsif(self.move_left?)
                @current_index[1]-=1
                @maze[@current_index[0]][@current_index[1]] = 'S' if @maze[@current_index[0]][@current_index[1]]!='E'
            end
            count+=1
            break if count==1000
        end
        self.print_maze
        if(@maze[@current_index[0]][@current_index[1]] == 'E')
            puts "We are done!"
        end
    end

    def read_maze(file_name)
        maze = []
        File.open(file_name).each_line do |line|
            chars = line.split(//)
            maze << chars
        end
        maze
    end

    def find_index(char)
        @maze.each_with_index do |row,row_index|
            row.each_with_index do |col, col_index|
                return [row_index, col_index] if @maze[row_index][col_index]==char
            end
        end
        return []
    end

    def print_maze
        # @maze.each do |line|
        #     line.each do |char|
        #         print char
        #     end
        #     puts "\n"
        # end
        # puts "\n"
        @maze.each do |line|
        puts line.join("")
      end
    end

    def move_up?
        next_index = @maze[@current_index[0]-1][@current_index[1]]
        (next_index != '*' && next_index != 'S') ? (return true) : (return false)
    end

    def move_right?
        next_index=@maze[@current_index[0]][@current_index[1]+1]
        (next_index != '*' && next_index != 'S') ? (return true) : (return false)
    end

    def move_down?
        next_index = @maze[@current_index[0]+1][@current_index[1]]
        (next_index != '*' && next_index != 'S') ? (return true) : (return false)
    end

    def move_left?
        next_index = @maze[@current_index[0]][@current_index[1]-1]
        (next_index != '*' && next_index != 'S') ? (return true) : (return false)
    end
end

maze=Maze.new("maze1.txt")
p "Start index is #{maze.start_index}"
p "Start index is #{maze.end_index}"
maze.run