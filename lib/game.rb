class Game
  attr_accessor :secret_word, :display_word

  def initialize()
    @wrong_guesses = 0
    @word_guessed = false
    @guesses = []
  end

  def generate_secret_word
    words = File.readlines(FILENAME, chomp: true).select{ |w| w.length.between?(5,12) }
    self.secret_word = words[rand(0..words.length)].upcase.split('')
    self.display_word = secret_word.map {|i| '_'}
  end

  def get_user_choice
    loop do
      print "Enter your guess(single character): "
      c = gets.chomp.upcase
      if @guesses.include?(c)
        puts "#{c.upcase} was already guessed. Try another character"
        next
      end
      return c if c.length == 1 && c.match(/[A-Z]/)
    end
  end

  def check_against_secret?(c)
    matching_indices = secret_word.each_index.select { |i| secret_word[i] == c}
    matching_indices.each do |i|
      display_word[i] = c
    end
    @wrong_guesses += 1 if matching_indices.empty? 
    return true if display_word == secret_word
    
    false
  end

  def is_game_over?
    @wrong_guesses == WRONG_MAX || @word_guessed
  end

  def play
    generate_secret_word
    until is_game_over?
      puts "Lives: #{WRONG_MAX - @wrong_guesses}"
      puts @display_word.join(' ')
      c = get_user_choice
      @guesses << c
      @word_guessed = check_against_secret?(c)
    end

    if @wrong_guesses < WRONG_MAX
      puts "You won!!"
    else
      puts "Sorry you lost!! The word was #{secret_word.join()}"
    end
  end
end