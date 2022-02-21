OPTIONS = ['R', 'O', 'Y', 'G', 'B', 'P']

class Game
  def initialize(codemaker, codebreaker)
    @codemaker = codemaker
    @codebreaker = codebreaker
  end

  def play
    loop do
      guess = @codebreaker.make_guess
      if correct?(guess)
        puts "\nNice job! You cracked the secret code :)"
        return
      elsif game_over?
        puts "\nDangit! You ran out of guesses :( The secret code was: #{@codemaker.code.join('')}."
        return
      else
        puts "\nCodemaker feedback: "
        @codemaker.feedback(guess)
        puts "You have #{@codebreaker.guesses_left} guesses left. Try again.\n\n"
      end
    end
  end

  def correct?(guess)
    guess == @codemaker.code
  end

  def game_over?
    @codebreaker.guesses_left.zero?
  end
end

class Codemaker
  attr_reader :code

  def initialize
    @code = [OPTIONS.sample, OPTIONS.sample, OPTIONS.sample, OPTIONS.sample]
  end

  def feedback(guess)
    leftover_guess = []
    leftover_code = []
    guess.each_with_index do |peg, index|
      if peg == @code[index]
        print 'B '
      else
        leftover_guess << peg
        leftover_code << @code[index]
      end
    end

    leftover_guess.uniq.each { |peg| print 'W ' if leftover_code.include?(peg) }
    puts ""
  end
end

class Codebreaker
  attr_accessor :guesses_left

  def initialize
    @guesses_left = 12
  end

  def make_guess
    puts "*R = red, O = orange, Y = yellow, G = green, B = blue, P = purple*\nEnter a guess of 4 colors, you can include duplicates: "
    guess = gets.chomp.split('')
    until guess_valid?(guess)
      puts "\nSorry, that is an invalid guess. Your guess must have 4 colors. The colors you can choose from are: R, O, Y, G, B, P. Please enter a valid guess: "
      guess = gets.chomp.split('')
    end
    @guesses_left -= 1
    guess
  end

  def guess_valid?(guess)
    return false if guess.length != 4

    guess.each { |peg| return false unless OPTIONS.include?(peg) }
    true
  end
end

Game.new(Codemaker.new, Codebreaker.new).play
