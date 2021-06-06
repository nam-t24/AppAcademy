require_relative 'card'
# require 'byebug'

class Hand
    attr_reader :cards
    SUITS = [:spade, :heart, :diamond, :club]
    CARD_VALUES = [:ace, :king, :queen, :jack, :ten, :nine, :eight, :seven, :six, :five, :four, :three, :two]

    def initialize(cards)
        raise "Must have 5 cards" if cards.length!=5;
        @cards=cards.sort
    end

    def self.winner(hands)
        hands.sort.last
    end

    def trade(take_cards, new_cards)
        raise "trades must be same amount" if take_cards.length != new_cards.length;
        take_cards.each do |card|
            raise "cannot discard unowned card" if !@cards.include?(card);
        end

        take_cards.each {|card| @cards.delete(card)}
        new_cards.each {|card| @cards << card}
        @cards.sort!
    end

    def to_s
        cards.join(' ')
    end

    #determining order of hands

    ORDER = [
    :royal_flush,
    :straight_flush,
    :four_of_a_kind,
    :full_house,
    :flush,
    :straight,
    :three_of_a_kind,
    :two_pair,
    :one_pair,
    :high_card
  ]

    def poker_hand
        #self.send calls in the method that we don't know of until runtime;
        ORDER.each do |rank|
            return rank if self.send("#{rank}?");
        end
        raise "Error, rank not found"
    end

    def <=>(hand)
        if self == hand
            return 0
        elsif (ORDER.index(self.poker_hand) < ORDER.index(hand.poker_hand))
            return 1
        elsif (ORDER.index(self.poker_hand) > ORDER.index(hand.poker_hand))
            return -1
        else
            return tie_breaker(hand)
        end
    end

    def highest_card
        @cards.sort!
        #making ace the lower card in straight when needed
        if self.poker_hand == :straight_flush || self.poker_hand == :flush
            if (@cards[0].value == :two && @cards[4].value == :ace)
                @cards.unshift(@cards.pop)
            end
        end
        @cards.last
    end

    private
    #methods to check poker hand (will be called by send methond)
    def royal_flush?
        royal = CARD_VALUES[0..4].reverse
        @cards.each_with_index do |card, idx|
            return false if card.value != royal[idx];
        end
        @cards.all? {|card| card.suit == @cards[0].suit}
    end

    def straight_flush?
        beginning_value = @cards[0].value
        beginning_index = CARD_VALUES.index(beginning_value)

        @cards.each_with_index do |card,idx|
            return false if card.value != CARD_VALUES[beginning_index];
            beginning_index-=1
            
            if idx==4 && (@cards[0].value == :two && @cards[4].value == :ace)
                return true
            end
        end

        @cards.all? {|card| card.suit == @cards[0].suit}
    end

    def four_of_a_kind?
        ranks = Hash.new(0)
        @cards.each do |card|
            ranks[card.value]+=1
        end
        ranks.each_value {|value| return true if value == 4};
        false
    end

    def full_house?
        ranks = Hash.new(0)
        @cards.each do |card|
            ranks[card.value]+=1
        end
        ranks.length == 2
    end

    def flush?
        @cards.all? {|card| card.suit == @cards[0].suit}
    end

    def straight?
        beginning_value = @cards[0].value
        beginning_index = CARD_VALUES.index(beginning_value)

        @cards.each_with_index do |card,idx|
            return false if card.value != CARD_VALUES[beginning_index];
            beginning_index-=1
            
            if idx==4 && (@cards[0].value == :two && @cards[4].value == :ace)
                return true
            end
        end
        true
    end

    def three_of_a_kind?
        ranks = Hash.new(0)
        @cards.each do |card|
            ranks[card.value]+=1
        end
        ranks.each_value {|value| return true if value == 3};
        false
    end

    def two_pair?
        ranks = Hash.new(0)
        @cards.each do |card|
            ranks[card.value]+=1
        end
        ranks.values.count(2) == 2
    end

    def one_pair?
        ranks = Hash.new(0)
        @cards.each do |card|
            ranks[card.value]+=1
        end
        ranks.values.count(2) == 1
    end

    def high_card?
        true
    end

    #tie breaker for certain hands;

    def tie_breaker(hand)
        case poker_hand
        when :royal_flush, :straight_flush, :straight
            self.highest_card <=> hand.highest_card
        when :flush, :high_card
            self.compare_highest_relative(hand)
        when :four_of_a_kind
            compare_set_then_high_card(4, hand)
        when :three_of_a_kind
            compare_set_then_high_card(3, hand)
        when :one_pair
            compare_set_then_high_card(2, hand)
        when :two_pair
            compare_two_pair(hand)
        when :full_house
            compare_full_house(hand)
        end
    end

    def compare_highest_relative(hand, n = 4)
        return @cards[0] <=> hand.cards[0] if n<=0;

        if ((@cards[n] <=> hand.cards[n])==0)
            compare_highest_relative(hand, n-1)
        else
            return @cards[n] <=> hand.cards[n]
        end

    end

    def compare_set_then_high_card(n, hand)
        self_hash=Hash.new(0)
        hand_hash=Hash.new(0)

        @cards.each {|card| self_hash[card.value] += 1}
        hand.cards.each {|card| hand_hash[card.value] += 1}

        if ((CARD_VALUES.index(self_hash.key(n)) <=> CARD_VALUES.index(hand_hash.key(n))) == 0)
            self_single = []
            hand_single=[]

            self_hash.each {|key, val| self_single << key if val ==1};
            hand_hash.each {|key, val| hand_single << key if val ==1};

            return compare_highest_from_pair(self_single, hand_single, 5-n-1)
        else
            return CARD_VALUES.index(hand_hash.key(n)) <=> CARD_VALUES.index(self_hash.key(n))
        end
        
    end

    def compare_highest_from_pair(self_single, hand_single, n)
        return CARD_VALUES.index(hand_single[0]) <=> CARD_VALUES.index(self_single[0]) if n<=0;

        if (CARD_VALUES.index(self_single[n]) <=> CARD_VALUES.index(hand_single[n])) == 0
            compare_highest_from_pair(self_single, hand_single, n-1)
        else
            return CARD_VALUES.index(hand_single[n]) <=> CARD_VALUES.index(self_single[n])
        end
    end

    def compare_two_pair(hand)
        self_hash=Hash.new(0)
        hand_hash=Hash.new(0)

        @cards.each {|card| self_hash[card.value] += 1}
        hand.cards.each {|card| hand_hash[card.value] += 1}

        self_keys=get_keys(self_hash, 2)
        hand_keys=get_keys(hand_hash, 2)

        self_highest = CARD_VALUES.index(self_keys[0]) < CARD_VALUES.index(self_keys[1]) ? self_keys[0] : self_keys[1];
        hand_highest = CARD_VALUES.index(hand_keys[0]) < CARD_VALUES.index(hand_keys[1]) ? hand_keys[0] : hand_keys[1];

        if (CARD_VALUES.index(self_highest) < CARD_VALUES.index(hand_highest))
            return 1
        elsif (CARD_VALUES.index(self_highest) > CARD_VALUES.index(hand_highest))
            return -1
        else
            #second lowerst pair
            self_second = CARD_VALUES.index(self_keys[0]) > CARD_VALUES.index(self_keys[1]) ? self_keys[0] : self_keys[1];
            hand_second = CARD_VALUES.index(hand_keys[0]) > CARD_VALUES.index(hand_keys[1]) ? hand_keys[0] : hand_keys[1];
            if (CARD_VALUES.index(self_second) < CARD_VALUES.index(hand_second))
                return 1
            elsif (CARD_VALUES.index(self_second) > CARD_VALUES.index(hand_second))
                return -1
            else
                self_high_card = self_hash.key(1)
                hand_high_card = hand_hash.key(1)
                if (CARD_VALUES.index(self_high_card) < CARD_VALUES.index(hand_high_card))
                    return 1
                elsif (CARD_VALUES.index(self_high_card) > CARD_VALUES.index(hand_high_card))
                    return -1
                else
                    return 0
                end
            end
        end

    end

    def get_keys(hash, value)
        arr=[]
        hash.each {|key, val| arr << key if val==value};
        arr
    end

    def compare_full_house(hand)
        self_hash=Hash.new(0)
        hand_hash=Hash.new(0)

        @cards.each {|card| self_hash[card.value] +=1}
        hand.cards.each {|card| hand_hash[card.value] +=1}

        self_three = self_hash.key(3)
        hand_three = hand_hash.key(3)
        self_two = self_hash.key(2)
        hand_two = hand_hash.key(2)

        if ((CARD_VALUES.index(hand_three)<=>CARD_VALUES.index(self_three)) == 0)
            return CARD_VALUES.index(hand_two)<=>CARD_VALUES.index(self_two)
        else
            return CARD_VALUES.index(hand_three)<=>CARD_VALUES.index(self_three)
        end
    end
end
