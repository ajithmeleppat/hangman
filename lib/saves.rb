module Saves
  @@FILEPATH = 'saves.json'

  def existing_saves()
    c = File.read(@@FILEPATH)
    File.exist?(@@FILEPATH) && !File.empty?(@@FILEPATH) ? JSON.parse(c) : {}
  end

  def add_save_state(name)
    new = {
        secret_word: @secret_word, 
        current_status: player.current_status, 
        wrong_guesses: player.wrong_guesses,
        guesses: player.guesses 
      }     
    data = existing_saves
    data[name] = new
    data
  end

  def save_game
    name = get_user_input("Enter name for savepoint: ")
    data = add_save_state(name)
    save_to_json(data)
    @game_over = true
  end

  def save_to_json(data)
    File.open(@@FILEPATH, 'w') do |f|
      f.write(JSON.pretty_generate(data))
    end
  end

  def load_savepoint_list
    content = existing_saves
    content.empty? ? {} : content.keys
  end

  def load_savepoint
    all_save_points = load_savepoint_list
    if all_save_points.empty?
      no_save_msg
      return false
    end
    save_point = get_save_point(all_save_points)
    data = existing_saves
    load_data(data[save_point])
    true
  end

  def load_data(input)
    player.current_status = input["current_status"]
    player.wrong_guesses = input["wrong_guesses"]
    player.guesses = input["guesses"]
    @secret_word = input["secret_word"]
  end
end