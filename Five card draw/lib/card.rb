class Card
    attr_reader :card, :suit, :value
    SUITS = [:spade, :heart, :diamond, :club]
    CARD_VALUES = [:ace, :king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two]
    def initialize(card)
        raise "Suit is not valid" unless SUITS.include?(card[0])
        raise "Card value is not valid" unless CARD_VALUES.include?(card[1])
        @card=card
        @suit = card[0]
        @value = card[1]
    end

    #redfine comparison
    def <=>(card)
        if CARD_VALUES.index(self.value) < CARD_VALUES.index(card.value)
            return 1
        elsif CARD_VALUES.index(self.value) > CARD_VALUES.index(card.value)
            return -1
        else
            #suits don't matter in poker
            # if SUITS.index(self.suit) < SUITS.index(card.suit)
            #     return 1
            # elsif SUITS.index(self.suit) > SUITS.index(card.suit)
            #     return -1
            # else
            #     return 0
            # end
            return 0
        end
    end

    def to_s
        "#{value}:#{suit}"
    end
end