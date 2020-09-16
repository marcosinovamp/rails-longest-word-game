require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @fin_time = Time.now.to_i
    @word = params[:word]
    @start_time = params[:start_time]
    @csnlet = params[:csnlet].gsub("\"","").gsub("[","").gsub("]","").split('').flatten
    @shwlet = @csnlet.each { |x| "#{x.upcase}, "}.join(', ')
    @test1 = word_test(@word, @csnlet)
    @test2 = engword_test(@word) unless @test1 == false
    @test3 = dletter_test(@word, @csnlet) unless @test1 == false || @test2 == false
    @scresult = points(@word, @fin_time, @start_time)
  end

  def word_test(word, letters)
    letres = []
    word.split('').each { |x| letres << letters.include?(x) }
    letres.include?(false) ? false : true
  end

  def engword_test(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    temp_result = open(url).read
    result = JSON.parse(temp_result)
    result['found']
  end

  def dletter_test(word, letters)
    wlet = {}
    plet = {}
    comp = []
    wtemp = word.split('')
    wtemp.each { |x| wlet[x] = wtemp.count(x) }
    letters.each { |x| plet[x] = letters.count(x) }
    comp = wtemp.reject { |x| wlet[x] > plet[x] }
    comp == wtemp ? true : false
  end

  def points(word, fin_time, start_time)
    pttotal = 0
    pttotal = word.length.to_i - (fin_time.to_i - start_time.to_i) * 0.1
  end

end
