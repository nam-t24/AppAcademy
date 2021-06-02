require 'tower_of_hanoi'
require 'rspec'

describe Tower do
    subject(:game) {Tower.new([[3,2,1], [], []], 2)}
    describe "#initialize" do
        it "sets array to be of length 3" do 
            expect(game.board.length).to eq(3)
        end

        it "sets winning stick to be any of the empty stick in board" do
            expect(game.winning_stick).to eq(1).or eq(2)
        end

        let(:non_valid) {Tower.new([[3,2,1], [], []], 0)}
        it "should raise error if stick is not valid" do 
            expect {non_valid.initialize}.to raise_error("Not a valid stick")
        end
    end

    describe "#make_move" do
        it "should correctly move top piece from start stick to end stick" do
            game.make_move(0,1)
            game.make_move(0,2)
            expect(game.board).to eq([[3],[1],[2]])
        end
    end

    describe "#valid_move" do
        let(:good) {Tower.new([[3,2,1], [], []], 1)}
        let(:bad) {Tower.new([[3,2,1], [], []], 1)}
        it "should return true if move is valid" do
            expect(good.valid_move(0,1)).to eq(true)
        end
        it "should return false if move is not valid" do
            bad.make_move(0,2)
            bad.make_move(0,1)
            expect(bad.valid_move(1,2)).to eq(false)
        end
    end


end