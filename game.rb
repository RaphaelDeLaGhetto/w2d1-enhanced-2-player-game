class Player
  attr_accessor :name, :lives, :points

  def initialize(name)
    @name = name
    @lives = 3
    @points = 0
  end
end

class Game

  def initialize
    @players = []
    @players << Player.new('Player 1')
    @players << Player.new('Player 2')
    @index = 0
    @values = (1..20).to_a
  end

  def play
    loop do
      break if @players[0].lives == 0 || @players[1].lives == 0 
      @index = @index % (@players.count)
      values_for_turn = generate_question

      print "\n#{prompt_player_for_answer(values_for_turn)} "
      answer = gets.chomp.to_i

      if verify_answer(answer, values_for_turn) 
        @players[@index].points += 1
      else
        @players[@index].lives -= 1
        puts "WRONG!"
        puts "#{@players[0].name} has #{@players[0].points} points"
        puts "#{@players[1].name} has #{@players[1].points} points"
      end
      @index += 1
    end

    puts "\n#{@players[0].points > @players[1].points ? @players[0].name : @players[1].name} wins!"
  end

  private

  def prompt_player_for_answer(vals)
    "#{@players[@index].name}: What does #{vals[0]} plus #{vals[1]} equal?"
  end

  def generate_question
    [@values.sample, @values.sample]
  end

  def verify_answer(answer, vals)
    answer == vals.inject(:+)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end