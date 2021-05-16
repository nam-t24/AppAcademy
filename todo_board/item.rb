require "byebug"
class Item
    attr_accessor :title, :description
    attr_reader :deadline, :done
    def deadline=(new_deadline)
        if (valid_date?(new_deadline))
            @deadline=new_deadline
        end
    end

    def initialize(title, deadline, description)
        if !Item.valid_date?(deadline)
            raise "deadline is not vailid"
        end
        @title=title
        @deadline=deadline
        @description=description
        @done = false
    end

    def self.valid_date?(date)
        dash=[]
        date.each_char.with_index {|char,idx| dash << idx if char=='-';}
        return false if dash.length!=2 || !(dash.include?(4)&&dash.include?(7)) || date.length!=10;
        month_int = date[5..6].to_i
        year_int = date[0..3].to_i
        day_int = date[8..9].to_i
        return false if (month_int<1 || month_int>12) || (day_int < 1 || day_int > 31);
        true
    end

    def toggle
        @done = !done
    end
end
