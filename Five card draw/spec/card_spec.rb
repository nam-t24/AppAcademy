require 'rspec'
require 'card'

describe Card do
    let(:new_card) { Card.new([:spade, :king]) }
    describe "#initialize" do 
        it "correctly assignes card" do
            expect(new_card.card).to eq([:spade, :king])
        end
        
        it "raises error if suit is not valid" do
            expect{Card.new([:circle, :king])}.to raise_error("Suit is not valid")
        end

        it "raises error if card value is not valid" do
            expect{Card.new([:spade, :zero])}.to raise_error("Card value is not valid")
        end
    end

    describe "#<=>" do
        let(:high_card) {Card.new([:spade,:ace])}
        let(:equal_card) {Card.new([:spade, :king])}
        let(:low_card) {Card.new([:spade, :three])}
        it "returns 1 if self value is higher than argument" do
            expect(high_card.<=>(new_card)).to eq(1)
        end

        it "returns -1 if self value is higher than argument" do
            expect(low_card.<=>(new_card)).to eq(-1)
        end

        it "returns 0 if self value is higher than argument" do
            expect(equal_card.<=>(new_card)).to eq(0)
        end
    end
end