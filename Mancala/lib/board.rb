require "byebug"
class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups=Array.new(14) {[]}
    @cups.each_with_index do |cup,idx|
      @cups[idx] = [:stone,:stone,:stone,:stone] if idx != 6 && idx != 13;
    end
    @name1=name1
    @name2=name2
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
  end

  def valid_move?(start_pos)
    # debugger
    raise "Invalid starting cup" if !((0...6).to_a.include?(start_pos) || (7...13).to_a.include?(start_pos));
    raise "Starting cup is empty" if @cups[start_pos].empty?;
  end

  def make_move(start_pos, current_player_name)
    amount=@cups[start_pos]
    @cups[start_pos]=[]
    idx=start_pos
    until amount.length==0
      idx=(idx+1)%14
      if(current_player_name == @name1 && idx!=13)
        @cups[idx] << :stone
        amount.shift
      elsif(current_player_name == @name2 && idx!=6)
        @cups[idx] << :stone
        amount.shift
      end
    end
    self.render
    next_turn(idx)

  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    return :switch if @cups[ending_cup_idx].length==1 && !(ending_cup_idx == 13 || ending_cup_idx == 6);
    return :prompt if ending_cup_idx == 13 || ending_cup_idx == 6
    ending_cup_idx
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    @cups[0..5].all? {|cup| cup.length==0} || @cups[7..12].all? {|cup| cup.length==0}
  end

  def winner
    return :draw if @cups[13].length == @cups[6].length
    return @name1 if @cups[13].length < @cups[6].length
    @name2
  end
end
