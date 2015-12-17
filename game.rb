
class InvalidGuessError < StandardError
end

class BlankNameError < StandardError
end

class Player
  attr_accessor :name, :lives, :points

  def initialize(name='')
    raise BlankNameError, 'Name cannot be blank' if name.empty?
    @name = name
    @lives = 3
    @points = 0
  end
end

class Game

  def initialize
    @players = []
    @index = 0
    @values = (1..20).to_a
  end

  def register_players
    player_num = 1 
    while @players.count < 2
      begin
        print "Player #{player_num}, enter your name: "
        @players << Player.new(gets.chomp)
        player_num += 1 
      rescue Exception => msg
        puts msg 
      end
    end
  end

  def play
    old_question = nil
    loop do
      break if @players[0].lives == 0 || @players[1].lives == 0 
      @index = @index % (@players.count)

      values_for_turn = old_question.nil? ? generate_question : old_question

      begin
        print "\n#{prompt_player_for_answer(values_for_turn)} "

        # This throws the ArgumentError if the given value can't be made into
        # an integer
        answer = Integer(gets.chomp)

        if verify_answer(answer, values_for_turn) 
          @players[@index].points += 1
        else
          @players[@index].lives -= 1
          puts "WRONG!"
          puts "#{@players[0].name} has #{@players[0].points} points"
          puts "#{@players[1].name} has #{@players[1].points} points"
        end
        @index += 1
        old_question = nil
      rescue ArgumentError => e
        puts "That is not a number! Try again..."
        old_question = values_for_turn
      end
    end

    puts @players[0].points == @players[1].points ? 'You tied' :  "\n#{@players[0].points > @players[1].points ? @players[0].name : @players[1].name} wins!"
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
  game.register_players
  game.play
end
