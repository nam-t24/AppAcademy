require 'tdd'
require 'rspec'

describe Array do
    describe "#uniq" do 
        it "removes dupes in array" do 
            expect([1, 2, 1, 3, 3].uniq).to eq([1,2,3])
        end
    end

    describe "#two_sum" do
        it "finds pairs of elements that add to 0 and return array of index pairs" do 
            expect([-1, 0, 2, -2, 1].two_sum).to eq([[0, 4], [2, 3]])
        end
    end

end

describe "#my_transpose" do
    let(:array) {[
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
    ]}
    it "transposes array" do
        expect(my_transpose(array)).to eq([[0, 3, 6], [1, 4, 7], [2, 5, 8]])
    end

    it "should not call #transpose" do
        expect(array).to_not receive(:transpose)
        my_transpose(array)
    end
end

describe "#stock_picker" do 
    it "return pairs of most profitable days" do
        array = [5,3,6,8,3,5,9,12]
        expect(stock_picker(array)).to eq([[1,7], [4,7]])
    end
end