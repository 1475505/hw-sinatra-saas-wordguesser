class WordGuesserGame

  attr_accessor :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses
  attr_accessor :word_with_guesses
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @word_with_guesses = '-' * word.length
    @guesses = ''
    @wrong_guesses = ''
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end

  def guess(letter)
    if letter == nil || (letter =~ /^\w+$/i) == nil
      raise ArgumentError
    end

    letter = letter.downcase

    if @guesses.include?(letter) || @wrong_guesses.include?(letter)
      return false
    end

    if @word.include?(letter)
      @guesses += letter
      while (i = @word.index(letter)) != nil
        @word_with_guesses[i] = letter
        @word[i] = '-'
      end
      true
    else
      @wrong_guesses += letter
      false
    end
  end

  def check_win_or_lose
    # code here
    if @wrong_guesses.length >= 7
      return :lose
    end

    if @word_with_guesses.include?('-')
      :play
    else
      :win
    end
  end

end
