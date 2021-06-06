require_relative './hand'

class Player
    attr_reader :amount, :current_bet, :hand

    def initialize(amount)
        @amount=amount
        @current_bet =0
    end
    
    def deal_in(hand)
        @hand = hand
    end

    def respond_bet
        print "(c)all, (b)et, or (f)old? > "
        response = gets.chomp.downcase[0]
        case response
        when 'c' then :call
        when 'b' then :bet
        when 'f' then :fold
        else
        puts 'not valid answer'
            respond_bet
        end
    end

    def get_bet
        print "Bet (bankroll: $#{amount}) > "
        bet = gets.chomp.to_i
        raise 'need more money' unless bet <= amount
        bet
    end

    def get_cards_to_trade
        print "Cards to trade? (ex. '1, 4, 5') > "
        card_indices = gets.chomp.split(', ').map(&:to_i)
        raise 'cannot trade more than three cards' unless card_indices.count <= 3;
        puts
        card_indices.map { |i| hand.cards[i - 1] }
    end
    
    def bet(total_bet)
        amount_bet = total_bet - @current_bet
        raise "need more money" unless amount_bet <= @amount
        @amount -= amount_bet
        @current_bet = total_bet
        amount_bet
    end

    def reset_current_bet
        @current_bet = 0
    end

    def winning(pot)
        @amount += pot
    end

    def return_cards
        cards = hand.cards
        @hand = nil
        cards
    end

    def fold
        @folded = true
    end

    def unfold
        @folded = false
    end

    def folded?
        @folded
    end

    def trade_cards(old_cards, new_cards)
        hand.trade(old_cards, new_cards)
    end

    def <=>(other_player)
        hand
        other_player.hand
        hand <=> other_player.hand
    end

end