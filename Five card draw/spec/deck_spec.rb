require 'rspec'
require 'deck'

describe Deck do

    describe "::generate_cards" do
        let(:cards) {Deck.generate_cards}
        it "generates a deck of 52 cards" do
            expect(cards.count).to eq(52)
        end

        it "should have all unique cards" do 
            expect(cards.map {|card| [card.suit, card.value]}.uniq.count).to eq(52)
        end
    end

    describe "#initialize" do
        let(:cards) do 
            [ double("card", :suit => :spades, :value => :king),
            double("card", :suit => :spades, :value => :queen) ]
        end

        it "generates 52 new cards if no args passed" do
            expect(Deck.new.cards.count).to eq(52)
        end

        it "assigns cards to array from argument" do
            expect(Deck.new(cards).cards.count).to eq(2)
        end
    end

    describe "#shuffle_cards" do
        let(:deck) {Deck.new}
        it "calls shuffle" do
            expect(deck.cards).to receive(:shuffle!)
            deck.shuffle_cards
        end
    end

end