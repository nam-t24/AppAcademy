require 'rspec'
require 'hand'
require 'card'

describe Hand do
    let(:cards) {[
        Card.new([:spade, :ten]),
        Card.new([:heart, :five]),
        Card.new([:heart, :ace]),
        Card.new([:diamond, :two]),
        Card.new([:heart, :two])
    ]}

    subject(:hand) { Hand.new(cards) }
    describe "#initialize" do 
      it "initializes cards to argument" do
        expect(hand.cards).to match_array(cards)
      end

      it "raises error if there are not 5 cards" do
        expect{Hand.new(cards[0..3])}.to raise_error("Must have 5 cards")
      end
    end

    describe "trade" do
      let!(:take_cards) { hand.cards[0..1] }
      let!(:new_cards) { [Card.new([:spade, :five]), Card.new([:club, :three])] }
      let!(:bad_new_cards) { [Card.new([:spade, :five]), Card.new([:club, :three]), Card.new([:heart, :ten])] }
      let(:hand_trade) {Hand.new(cards)}
      
      it "raises error if amount of cards switched it not same" do
        expect{hand.trade(take_cards, bad_new_cards)}.to raise_error("trades must be same amount")
      end
      it "takes out specified cards" do
        hand_trade.trade(take_cards, new_cards)
        expect(hand_trade.cards).to_not include(*take_cards)
      end
      it "takes in specified cards" do
        hand_trade.trade(take_cards, new_cards)
        expect(hand_trade.cards).to include(*new_cards)
      end
      it 'raises an error if there is unowned card' do
        expect do
          hand_trade.trade([Card.new([:heart, :ten])], new_cards[0..0])
        end.to raise_error("cannot discard unowned card")
      end
    end

    
    let(:royal_flush) do
      Hand.new([
        Card.new([:spade, :ace]),
        Card.new([:spade, :king]),
        Card.new([:spade, :queen]),
        Card.new([:spade, :jack]),
        Card.new([:spade, :ten])
      ])
    end
    let(:straight_flush) do
      Hand.new([
        Card.new([:spade, :eight]),
        Card.new([:spade, :seven]),
        Card.new([:spade, :six]),
        Card.new([:spade, :five]),
        Card.new([:spade, :four])
      ])
    end
    let(:four_of_a_kind) do
      Hand.new([
        Card.new([:spade, :ace]),
        Card.new([:heart, :ace]),
        Card.new([:diamond, :ace]),
        Card.new([:club, :ace]),
        Card.new([:spade, :ten])
      ])
    end
    let(:full_house) do
      Hand.new([
        Card.new([:spade, :ace]),
        Card.new([:club, :ace]),
        Card.new([:spade, :king]),
        Card.new([:heart, :king]),
        Card.new([:diamond, :king])
      ])
    end
    let(:flush) do
      Hand.new([
        Card.new([:spade, :four]),
        Card.new([:spade, :seven]),
        Card.new([:spade, :ace]),
        Card.new([:spade, :two]),
        Card.new([:spade, :eight])
      ])
    end
    let(:straight) do
      Hand.new([
        Card.new([:heart, :king]),
        Card.new([:heart, :queen]),
        Card.new([:diamond, :jack]),
        Card.new([:club, :ten]),
        Card.new([:spade, :nine])
      ])
    end
    let(:three_of_a_kind) do
      Hand.new([
        Card.new([:spade, :three]),
        Card.new([:diamond, :three]),
        Card.new([:heart, :three]),
        Card.new([:spade, :jack]),
        Card.new([:spade, :ten])
      ])
    end
    let(:two_pair) do
      Hand.new([
        Card.new([:heart, :king]),
        Card.new([:diamond, :king]),
        Card.new([:spade, :queen]),
        Card.new([:club, :queen]),
        Card.new([:spade, :ten])
      ])
    end
    let(:one_pair) do
      Hand.new([
        Card.new([:spade, :ace]),
        Card.new([:spade, :ace]),
        Card.new([:heart, :queen]),
        Card.new([:diamond, :jack]),
        Card.new([:heart, :ten])
      ])
    end
    let(:high_card) do
      Hand.new([
        Card.new([:spade, :two]),
        Card.new([:heart, :four]),
        Card.new([:diamond, :six]),
        Card.new([:spade, :nine]),
        Card.new([:spade, :ten])
      ])
    end
    let(:hand_ranks) do
      [
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
    end
    describe "#poker_hand" do
      context "when royal flush" do
        it "returns royal flush correctly" do
          expect(royal_flush.poker_hand).to eq(:royal_flush)
        end
      end
      context "when straight flush" do 
        it "returns straight flush correctly" do
          expect(straight_flush.poker_hand).to eq(:straight_flush)
        end
      end
      context "when four of a kind" do 
        it "returns four_of_a_kind correctly" do
          expect(four_of_a_kind.poker_hand).to eq(:four_of_a_kind)
        end 
      end
      context "when full house" do
        it "returns full house correctly" do
          expect(full_house.poker_hand).to eq(:full_house)
        end
      end
      context "when flush" do 
        it "returns flush correctly" do
          expect(flush.poker_hand).to eq(:flush)
        end
      end
      context "when straight" do
        it "returns straight correctly" do 
          expect(straight.poker_hand).to eq(:straight)
        end
      end
      context "when three of a kind" do
        it "returns three of a kind correctly" do
          expect(three_of_a_kind.poker_hand).to eq(:three_of_a_kind)
        end
      end
      context "when two pair" do
        it "returns two pair correctly" do
          expect(two_pair.poker_hand).to eq(:two_pair)
        end
      end
      context "when one pair" do 
        it "returns one pair correctly" do
          expect(one_pair.poker_hand).to eq(:one_pair)
        end
      end
      context "when high card" do
        it "returns high card correctly" do
          expect(high_card.poker_hand).to eq(:high_card)
        end
      end
    end

    describe "#<=>" do
      it 'returns 1 for a hand with a higher rank' do
        expect(royal_flush <=> straight_flush).to eq(1)
      end

      it 'returns -1 for a hand with a lower rank' do
        expect(straight_flush <=> royal_flush).to eq(-1)
      end

      it 'returns 0 for identical hands' do
        expect(straight_flush <=> straight_flush).to eq(0)
      end

      context "in a tie breaker" do
        context "when royal flush" do
          let(:heart_royal_flush) do
            Hand.new([
              Card.new([:heart, :ace]),
              Card.new([:heart, :king]),
              Card.new([:heart, :queen]),
              Card.new([:heart, :jack]),
              Card.new([:heart, :ten])
            ])
          end

          let(:spade_royal_flush) do
            Hand.new([
              Card.new([:spade, :ace]),
              Card.new([:spade, :king]),
              Card.new([:spade, :queen]),
              Card.new([:spade, :jack]),
              Card.new([:spade, :ten])
            ])
          end
          it "returns 0" do
            expect(expect(heart_royal_flush <=> spade_royal_flush).to eq(0))
          end
        end
        context "when straight flush" do
          let(:straight_flush_eight) do
            Hand.new([
              Card.new([:spade, :eight]),
              Card.new([:spade, :seven]),
              Card.new([:spade, :six]),
              Card.new([:spade, :five]),
              Card.new([:spade, :four])
            ])
          end

          let(:straight_flush_nine) do
            Hand.new([
              Card.new([:spade, :nine]),
              Card.new([:spade, :eight]),
              Card.new([:spade, :seven]),
              Card.new([:spade, :six]),
              Card.new([:spade, :five])
            ])
          end

          let(:heart_flush_nine) do
            Hand.new([
              Card.new([:heart, :nine]),
              Card.new([:heart, :eight]),
              Card.new([:heart, :seven]),
              Card.new([:heart, :six]),
              Card.new([:heart, :five])
            ])
          end

          it 'compares based on high card' do
            expect(straight_flush_nine <=> straight_flush_eight).to eq(1)
            expect(straight_flush_eight <=> straight_flush_nine).to eq(-1)
            expect(straight_flush_nine <=> heart_flush_nine).to eq(0)
          end
        end
        context "when straight" do 
          let(:straight_low) do
            Hand.new([
              Card.new([:spade, :eight]),
              Card.new([:heart, :seven]),
              Card.new([:spade, :six]),
              Card.new([:spade, :five]),
              Card.new([:club, :four])
            ])
          end

          let(:straight_high) do
            Hand.new([
              Card.new([:spade, :nine]),
              Card.new([:spade, :eight]),
              Card.new([:club, :seven]),
              Card.new([:spade, :six]),
              Card.new([:heart, :five])
            ])
          end

          let(:straight_high_tie) do
            Hand.new([
              Card.new([:heart, :nine]),
              Card.new([:heart, :eight]),
              Card.new([:club, :seven]),
              Card.new([:spade, :six]),
              Card.new([:heart, :five])
            ])
          end
          it 'compares based on high card' do
            expect(straight_high <=> straight_low).to eq(1)
            expect(straight_low <=> straight_high).to eq(-1)
            expect(straight_high <=> straight_high_tie).to eq(0)
          end
        end
        context "when flush" do
          let(:high_flush) do
            Hand.new([
              Card.new([:heart, :nine]),
              Card.new([:heart, :two]),
              Card.new([:heart, :ace]),
              Card.new([:heart, :jack]),
              Card.new([:heart, :five])
            ])
          end
          let(:low_flush) do
            Hand.new([
              Card.new([:spade, :nine]),
              Card.new([:spade, :two]),
              Card.new([:spade, :ace]),
              Card.new([:spade, :jack]),
              Card.new([:spade, :three])
            ])
          end
          let(:high_flush_tie) do
            Hand.new([
              Card.new([:club, :nine]),
              Card.new([:club, :two]),
              Card.new([:club, :ace]),
              Card.new([:club, :jack]),
              Card.new([:club, :five])
            ])
          end

          it "compares based on highest relative card" do
            expect(high_flush<=>low_flush).to eq(1)
            expect(low_flush<=>high_flush).to eq(-1)
            expect(high_flush<=>high_flush_tie).to eq(0)
          end
        end
        context "when high card" do
          let(:ten_high) do
            Hand.new([
              Card.new([:spade, :two]),
              Card.new([:heart, :four]),
              Card.new([:diamond, :six]),
              Card.new([:spade, :nine]),
              Card.new([:spade, :ten])
            ])
          end

          let(:king_high) do
            Hand.new([
              Card.new([:spade, :two]),
              Card.new([:heart, :four]),
              Card.new([:diamond, :six]),
              Card.new([:spade, :nine]),
              Card.new([:spade, :king])
            ])
          end
          it "compares based on highest relative card" do
            expect(ten_high<=>king_high).to eq(-1)
            expect(king_high<=>ten_high).to eq(1)
          end
        end
        context "when four of a kind" do
          let(:ace_four) do
            Hand.new([
              Card.new([:spade, :ace]),
              Card.new([:heart, :ace]),
              Card.new([:diamond, :ace]),
              Card.new([:club, :ace]),
              Card.new([:spade, :ten])
            ])
          end

          let(:king_four) do
            Hand.new([
              Card.new([:spade, :king]),
              Card.new([:heart, :king]),
              Card.new([:diamond, :king]),
              Card.new([:club, :king]),
              Card.new([:spade, :ten])
            ])
          end

          it "compares based on four of a kind value" do
            expect(ace_four <=> king_four).to eq(1)
            expect(king_four <=> ace_four).to eq(-1)
          end

          let(:ace_with_two) do
            Hand.new([
              Card.new([:spade, :ace]),
              Card.new([:heart, :ace]),
              Card.new([:diamond, :ace]),
              Card.new([:club, :ace]),
              Card.new([:spade, :two])
            ])
          end

          it 'compares based on high card value if same four of a kind value' do
            expect(ace_four <=> ace_with_two).to eq(1)
            expect(ace_with_two <=> ace_four).to eq(-1)
          end

          let(:ace_with_two_heart) do
            Hand.new([
              Card.new([:spade, :ace]),
              Card.new([:heart, :ace]),
              Card.new([:diamond, :ace]),
              Card.new([:club, :ace]),
              Card.new([:heart, :two])
            ])
          end

          it 'compares based on tie of high card' do
            expect(ace_with_two <=> ace_with_two_heart).to eq(0)
          end
        end
        context 'when two pair' do
          let(:two_pair_3_4) do
            Hand.new([
              Card.new([:spade, :three]),
              Card.new([:heart, :three]),
              Card.new([:heart, :four]),
              Card.new([:diamond, :four]),
              Card.new([:heart, :ten])
            ])
          end

          let(:two_pair_4_5) do
            Hand.new([
              Card.new([:spade, :five]),
              Card.new([:heart, :five]),
              Card.new([:heart, :four]),
              Card.new([:diamond, :four]),
              Card.new([:heart, :ten])
            ])
          end

          let(:pair_of_sixes) do
            Hand.new([
              Card.new([:spade, :six]),
              Card.new([:heart, :six]),
              Card.new([:heart, :four]),
              Card.new([:diamond, :five]),
              Card.new([:heart, :ten])
            ])
          end

          it 'two pair beats one pair' do
            expect(two_pair_4_5 <=> pair_of_sixes).to eq(1)
          end

          it 'higher of two pairs wins' do
            expect(two_pair_4_5 <=> two_pair_3_4).to eq(1)
          end
        end
        context 'when one pair' do
          let(:ace_pair) do
            Hand.new([
              Card.new([:spade, :ace]),
              Card.new([:spade, :ace]),
              Card.new([:heart, :queen]),
              Card.new([:diamond, :jack]),
              Card.new([:heart, :ten])
            ])
          end

          let(:king_pair) do
            Hand.new([
              Card.new([:spade, :king]),
              Card.new([:spade, :king]),
              Card.new([:heart, :queen]),
              Card.new([:diamond, :jack]),
              Card.new([:heart, :ten])
            ])
          end

          let(:three_pair_jack_high) do
            Hand.new([
              Card.new([:spade, :three]),
              Card.new([:heart, :three]),
              Card.new([:diamond, :nine]),
              Card.new([:heart, :jack]),
              Card.new([:heart, :ten])
            ])
          end

          let(:three_pair_king_high) do
            Hand.new([
              Card.new([:spade, :three]),
              Card.new([:heart, :three]),
              Card.new([:diamond, :nine]),
              Card.new([:heart, :king]),
              Card.new([:heart, :ten])
            ])
          end

          let(:four_pair) do
            Hand.new([
              Card.new([:spade, :four]),
              Card.new([:heart, :four]),
              Card.new([:diamond, :ace]),
              Card.new([:heart, :two]),
              Card.new([:heart, :three])
            ])
          end

          it 'should compare based on pair value' do
            expect(ace_pair <=> king_pair).to eq(1)
            expect(four_pair <=> three_pair_jack_high).to eq(1)
          end

          let(:ace_pair_king_high) do
            Hand.new([
              Card.new([:spade, :ace]),
              Card.new([:spade, :ace]),
              Card.new([:heart, :king]),
              Card.new([:diamond, :jack]),
              Card.new([:heart, :ten])
            ])
          end

          it 'should compare based on high card if same pair value' do
            expect(ace_pair_king_high <=> ace_pair).to eq(1)
            expect(three_pair_king_high <=> three_pair_jack_high).to eq(1)
          end
        end
        context "when full house" do
          let(:high_full) do
            Hand.new([
              Card.new([:spade, :ace]),
              Card.new([:spade, :ace]),
              Card.new([:heart, :ace]),
              Card.new([:diamond, :king]),
              Card.new([:heart, :king])
            ])
          end

          let(:low_full) do
            Hand.new([
              Card.new([:spade, :three]),
              Card.new([:spade, :three]),
              Card.new([:heart, :three]),
              Card.new([:diamond, :five]),
              Card.new([:heart, :five])
            ])
          end

          it "compares set of 3 first" do
            expect(high_full <=> low_full).to eq(1)
            expect(low_full <=> high_full).to eq(-1)
          end

          let(:high_full_low) do
            Hand.new([
              Card.new([:club, :ace]),
              Card.new([:heart, :ace]),
              Card.new([:diamond, :ace]),
              Card.new([:club, :three]),
              Card.new([:spade, :three])
            ])
          end

          it "compares on 2 second" do
            expect(high_full <=> high_full_low).to eq(1)
            expect(high_full_low <=> high_full).to eq(-1)
          end

          it "ties when all sets are same" do
            expect(high_full_low <=> high_full_low).to eq(0)
          end
        end
        describe '::winner' do
          it 'returns the winning hand' do
            high_hands = [flush, straight_flush, one_pair]
            expect(Hand.winner(high_hands)).to eq(straight_flush)
            
            low_hands = [one_pair, two_pair, three_of_a_kind]
            expect(Hand.winner(low_hands)).to eq(three_of_a_kind)
          end
        end
      end
    end
end