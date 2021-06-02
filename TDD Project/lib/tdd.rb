class Array
    def uniq
        new_arr=[]
        self.each do |ele|
            new_arr << ele if !new_arr.include?(ele);
        end
        new_arr
    end

    def two_sum
        pair_arr=[]
        (0...self.length-1).each do |i|
            ((i+1)...self.length).each do |j|
                pair_arr << [i,j] if self[i]+self[j]==0;
            end
        end
        pair_arr
    end
end

def my_transpose(array)
    transposed_arr = []
    (0...array.length).each do |row_idx|
        row=[]
        (0...array.length).each do |col_idx|
            row << array[col_idx][row_idx]
        end
        transposed_arr << row
    end
    transposed_arr
end

def stock_picker(array)
    l = array.length
    profit_arr=[]
    max=0
    (0...(l-1)).each do |first|
        (0...l).each do |second|
            profit = array[second] - array[first]
            if profit > max
                profit_arr=[]
                profit_arr << [first,second]
                max=profit
            elsif profit==max
                profit_arr << [first,second]
            end
        end
    end
    profit_arr
end