require "byebug"
require_relative './item.rb'

class List
    attr_accessor :label

    def initialize(label)
        @label=label
        @items=[]
    end

    def add_item(title, deadline, description="")
        if Item.valid_date?(deadline)
            item= Item.new(title, deadline, description)
            @items << item
            return true
        end
        false
    end

    def size
        return @items.length
    end

    def valid_index?(index)
        index >= self.size || index < 0 ? false : true
    end

    def swap(index_1, index_2)
        return false if !valid_index?(index_1) || !valid_index?(index_2)
        @items[index_1], @items[index_2] = @items[index_2], @items[index_1]
        true
    end

    def [](index)
        valid_index?(index) ? @items[index] : nil
    end

    def priority
        return @items[0]
    end

    def print
        p "------------------"
        p @label
        p "------------------"
        p "Index".ljust(5) + "| Item".ljust(20) + "| Deadline".ljust(15) + "| Status"
        p "-------------------------------------------------------------------------"
        @items.each_with_index do |item ,idx|
            p "#{idx}".ljust(5) + "| #{item.title}".ljust(20) + "| #{item.deadline}".ljust(15) +"| #{item.done}"
        end
        p "-------------------------------------------------------------------------"
        return
    end

    def print_full_item(index)
        if valid_index?(index)
            p "------------------------------------------"
            p "#{@items[index].title}".ljust(25) + "#{@items[index].deadline}"
            p "#{@items[index].description}".ljust(25) + "#{@items[index].done}"
            p "------------------------------------------"
            return
        end
    end
    
    def print_priority
        self.print_full_item(0)
    end

    def up(index, amount=1)
        return false if !valid_index?(index)
        current=index
        count=0
        while(count < amount && current!=0)
            @items[current],@items[current-1] = @items[current-1],@items[current]
            count+=1
            current-=1
        end
        true
    end
    def down(index, amount=1)
        return false if !valid_index?(index)
        current=index
        count=0
        while(count < amount && current!=@items.length-1)
            @items[current],@items[current+1] = @items[current+1],@items[current]
            count+=1
            current+=1
        end
        true
    end

    def sort_by_date!
        @items.sort_by! {|item| item.deadline}
    end

    def toggle_item(index)
        @items[index].toggle if valid_index?(index);
    end

    def remove_item(index)
        if valid_index?(index)
            @items.delete_at(index)
            return true
        end
        false
    end

    def purge
        i=0
        while i<@items.length
            if @items[i].done
                @items.delete_at(i)
            else
                i+=1
            end
        end
    end
end