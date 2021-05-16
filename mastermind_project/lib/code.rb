require "byebug"
class Code
  POSSIBLE_PEGS = {
    "R" => :red,
    "G" => :green,
    "B" => :blue,
    "Y" => :yellow
  }
  def self.valid_pegs?(arr)
    arr.all? {|ele| POSSIBLE_PEGS.has_key?(ele.upcase)}
  end

  def initialize(array)
    if(self.class.valid_pegs?(array))
      @pegs=array.map! {|ele| ele.upcase}
    else
      raise "error"
    end
  end
  def pegs
    @pegs
  end

  def self.random(length)
    arr=[]
    (0...length).each do |num|
      arr<<POSSIBLE_PEGS.keys.sample
    end
    Code.new(arr)
  end

  def self.from_string(string)
    arr=string.split("")
    Code.new(arr)
  end
  def [](index)
    @pegs[index]
  end
  def length
    @pegs.length
  end

  def num_exact_matches(code_guess)
    count=0
    @pegs.each_with_index {|color,index| count+=1 if color==code_guess.pegs[index]}
    count
  end
  def num_near_matches(code_guess)
    count=0
    code_guess.pegs.each {|color| count+=1 if @pegs.include?(color)}
    count-=num_exact_matches(code_guess)
    count
  end

  def ==(code)
    return false if self.pegs.length!=code.pegs.length
    self.pegs==code.pegs
  end
end
