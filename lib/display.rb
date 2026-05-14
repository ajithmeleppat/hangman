module Display
  def get_user_input(msg)
    print msg
    gets.chomp.upcase
  end

  def get_user_choice
    loop do
      c = get_user_input("Enter your guess(single character): ")
      if player.guesses.include?(c)
        puts "#{c.upcase} was already guessed. Try another character"
        next
      end
      return c if c.length == 1 && c.match(/[A-Z]/)
    end
  end

  def load_or_new
    puts "Welcome to Hangman!!"
    input = ''
    loop do
      input = get_user_input("Load existing game? (Y/N) :")
      break if %w[Y N].include?(input)
    end
    input
  end

  def display_current_status
    puts "\n#{'*'*10}HANGMAN#{'*'*10}\n\n"
    puts player.current_status.join(' ')
    puts "\nLives: #{WRONG_MAX - player.wrong_guesses} | Guesses: #{player.guesses}"
    puts "\n#{'*'*10}HANGMAN#{'*'*10}\n\n"
  end

  def no_save_msg
    puts "No save points yet. Please save a game before loading!!"
  end

  def game_end_msg
    unless @save_game
      if player.wrong_guesses < WRONG_MAX
        puts "You won!!"
      else
        puts "Sorry you lost!! The word was #{secret_word.join()}"
      end
    end
    puts "Game Saved." if @save_game
  end

  def user_chose_save?
    input = ''
    loop do
      input = get_user_input("Save game and exit (Y/N):")
      break if %w[Y N].include?(input)
    end
    input == 'Y' ? true : false
  end

  def get_save_point(all_save_points)
    input = ''
    puts "Available savepoints #{all_save_points}"
    loop do
      input = get_user_input("Chose the savepoint to load:")
      break if all_save_points.include?(input)
    end
    input
  end
end