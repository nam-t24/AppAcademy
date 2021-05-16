require_relative './list.rb'
class TodoBoard
    def initialize()
        @boards=Hash.new()
        
    end

    def get_command
        p "Enter command-"
        cmd, *args = gets.chomp.split(' ')
        case cmd
        when 'mklist'
            @boards[*args]=List.new(*args)
        when 'ls'
            p @boards.keys
        when 'showall'
            @boards.each do |key, value|
                value.print
            end
        when 'mktodo'
            @boards[args[0]].add_item(*args[1..-1])
        when 'up'
            args.map!.with_index {|ele,idx| idx==0 ? ele : ele.to_i}
            @boards[args[0]].up(*args[1..-1])
        when 'down'
            args.map!.with_index {|ele,idx| idx==0 ? ele : ele.to_i}
            @boards[args[0]].down(*args[1..-1])
        when 'swap'
            args.map!.with_index {|ele,idx| idx==0 ? ele : ele.to_i}
            @boards[0].swap(*args[1..-1])
        when 'sort'
            @boards[*args].sort_by_date!
        when 'priority'
            @boards[*args].print_priority
        when 'print'
            args.map!.with_index {|ele,idx| idx==0 ? ele : ele.to_i}
            args.length==1 ? @boards[*args].print : @boards[args[0]].print_full_item(*args[1..-1])
        when 'toggle'
            args.map!.with_index {|ele,idx| idx==0 ? ele : ele.to_i}
            @boards[args[0]].toggle_item(*args[1..-1])
        when 'rm'
            args.map!.with_index {|ele,idx| idx==0 ? ele : ele.to_i}
            @boards[args[0]].remove_item(*args[1..-1])
        when 'purge'
            @boards[*args].purge
        when 'quit'
            return false
        else
            print "Sorry, that command is not recognized."
        end
        true
    end

    def run
        while(get_command)
            self.get_command
        end
        p "done"
        return
    end
end

todo_board=TodoBoard.new()
todo_board.run