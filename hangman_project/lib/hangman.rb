class Hangman
  DICTIONARY = ["cat", "dog", "bootcamp", "pizza"]

  def self.random_word
    DICTIONARY.sample
  end

  def initialize()
    @secret_word = self.class.random_word
    @guess_word=Array.new(@secret_word.length, '_')
    @attempted_chars=[]
    @remaining_incorrect_guesses = 5
  end

  def guess_word
    @guess_word
  end

  def attempted_chars
    @attempted_chars
  end

  def remaining_incorrect_guesses
    @remaining_incorrect_guesses
  end

  def already_attempted?(char)
    return true if @attempted_chars.include? char
    false
  end

  def get_matching_indices(char)
    new_arr=[]
    @secret_word.each_char.with_index do |letter, idx|
      if letter==char
        new_arr<<idx
      end
    end
    new_arr
  end

  def fill_indices(char, idx_arr)
    idx_arr.each {|idx| @guess_word[idx]=char}
  end

  def try_guess(char)
    if(already_attempted?(char))
      puts "that has already been attempted"
      return false
    else
      @attempted_chars<<char
      arr=get_matching_indices(char)
      if(!arr.empty?)
        fill_indices(char,arr)
      else
        @remaining_incorrect_guesses-=1
      end
      return true
    end
  end

  def ask_user_for_guess()
    puts "Enter a char:"
    char= gets.chomp
    try_guess(char)
  end

  def win?
    if (@guess_word.join==@secret_word)
      puts "WIN"
      return true
    end
    false
  end

  def lose?
    if(@remaining_incorrect_guesses==0)
      print "LOSE"
      return true
    end
    false
  end
  def game_over?
    return false if !self.win? && !self.lose?
    puts @secret_word
    true
  end
end
