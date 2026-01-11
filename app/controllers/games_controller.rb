require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
    # word.chars This takes the user's string (e.g., "APPLE") and turns it into an array of individual characters: ["A", "P", "P", "L", "E"].
    # all? If the question is true for every letter, the whole thing returns true.
    # If even one letter fails the test, it immediately returns false
    # For every letter in the user's word, it compares two counts:
    # word.count(letter): "How many times did the user use this letter?"
    # letters.count(letter): "How many times did the computer provide this letter?"
    # <= sign because the rule says: "You can use exactly what I gave you, or less, but never more."
  end

  def english_word?(word)
    response = URI.open("https://dictionary.lewagon.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
