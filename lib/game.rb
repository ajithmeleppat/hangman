require './lib/player'
require './lib/display'
require './lib/saves'

class Game
  include Display
  include Saves

  attr_accessor :secret_word, :current_status, :player

  def initialize()
    @word_guessed = false
    self.player = Player.new
  end

  def generate_secret_word
    words = File.readlines(FILENAME, chomp: true).select{ |w| w.length.between?(5,12) }
    self.secret_word = words[rand(0..words.length)].upcase.split('')
    player.current_status = secret_word.map {|i| '_'}
  end

  def check_against_secret?(c)
    matching_indices = secret_word.each_index.select { |i| secret_word[i] == c}
    matching_indices.each do |i|
      player.current_status[i] = c
    end
    player.wrong_guesses += 1 if matching_indices.empty? 
    return true if player.current_status == secret_word
    
    false
  end

  def is_game_over?
    player.wrong_guesses == WRONG_MAX || @word_guessed
  end

  def play_round
    c = get_user_input("Enter your guess(single character):")
    player.guesses << c
    @word_guessed = check_against_secret?(c)
    display_current_status
    @game_over = is_game_over?
    return if @game_over
    @save_game = user_chose_save? 
    save_game if @save_game
  end

  def start_game
    @save_game = false
    @game_over = false
    display_current_status
    until @game_over
      play_round
      
    end
    game_end_msg
  end

  def play
    if load_or_new == 'Y'
      game_loaded = load_savepoint
    else
      generate_secret_word
      game_loaded = true
    end
    start_game if game_loaded
  end
end