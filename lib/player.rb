require 'json'

class Player
  attr_accessor :current_status, :wrong_guesses, :guesses
  

  def initialize()
    @wrong_guesses = 0
    @guesses = []
    @saved_games = []
  end

  
end