require_relative './card.rb'
require_relative './hand.rb'
class Deck
    attr_reader :cards
    def self.generate_cards
        cards=[]
        Card::SUITS.each do |suit|
            Card::CARD_VALUES.each do |value|
                cards << Card.new([suit, value])
            end
        end
        cards
    end

    def initialize(cards = Deck.generate_cards)
        @cards = cards
    end

    def deal_hand
        Hand.new(take(5))
    end

    def count
        @cards.count
    end

    def take(n)
        raise "not enough cards" if n > count
        @cards.shift(n)
    end

    def return(cards)
        @cards.push(*cards)
    end

    def shuffle_cards
        @cards.shuffle!
    end
end