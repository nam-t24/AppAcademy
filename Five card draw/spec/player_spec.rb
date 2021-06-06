require 'rspec'
require 'player'

describe Player do
    subject(:player) { Player.new(100) }

    describe "#initialize" do
        it "should set current bet to 0" do
            expect(player.current_bet).to eq(0)
        end
        it "should set starting amount to argument" do
            expect(player.amount).to eq(100)
        end
    end

    describe '#deal_in' do
        let(:hand) { double ('hand') }

        it 'should set the players hand' do
            player.deal_in(hand)
            expect(player.hand).to eq(hand)
        end
    end

    describe "#bet" do
        it "should decrease bet from amount" do
            expect do
                player.bet(10)
            end.to change { player.amount }.by(-10)
        end

        it 'should decrement the players amount by the raise amount' do
            player.bet(10)
                expect do
                player.bet(20)
            end.to change { player.amount }.by(-10)
        end

        it 'should return the amount deducted' do
            expect(player.bet(10)).to eq(10)
        end

        it 'should raise an error if the bet is more than the amount' do
            expect do
                player.bet(1000)
            end.to raise_error 'need more money'
        end
    end
end