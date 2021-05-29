class Simon
  COLORS = %w(red blue green yellow)

  attr_accessor :sequence_length, :game_over, :seq

  def initialize
    @sequence_length=1
    @game_over = false
    @seq=[]
  end

  def play
    system("clear")
    until game_over == true
      take_turn
      system("clear")
    end
    game_over_message
    reset_game
    puts "Play another? (y/n)"
    answer = gets.chomp
    if (answer == "y")
      self.play
    end

  end

  def take_turn
    show_sequence
    require_sequence
    if game_over == false
      round_success_message
      sleep(0.5)
      @sequence_length+=1
    end
  end

  def show_sequence
    add_random_color
    sleep(1)
    @seq.each do |color|
      puts color
      sleep(1)
      system("clear")
      sleep(0.25)
    end
  end

  def require_sequence
    @sequence_length.times do |i|
      p "Enter the sequence one at a time (red, green, blue, yellow)"
      entered_color = gets.chomp
      if (entered_color!= @seq[i])
        @game_over = true
        break
      end
    end
    sleep(0.5)
  end

  def add_random_color
    random_color = COLORS.sample
    @seq << random_color

  end

  def round_success_message
    puts "You passed the round"
  end

  def game_over_message
    puts "Game over. Your score is #{@sequence_length - 1}"

  end

  def reset_game
    @sequence_length = 1
    @game_over = false
    @seq = []

  end
end

game=Simon.new
game.play