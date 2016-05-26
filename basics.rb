require 'rubygems'
require 'sinatra'
require 'httparty'
require 'json'
require 'byebug'
require 'date'
require 'chartkick'

get '/' do
  erb :form
end

post '/' do
  finish = Date.today-30
  start = Date.today-60
  finish_str = "&d=#{finish.strftime("%m")}&e=#{finish.strftime("%d")}&f=#{finish.year}"
  begin_str = "&a=#{start.strftime("%m")}&b=#{start.strftime("%d")}&c=#{start.year}"
  uri = "http://ichart.finance.yahoo.com/table.csv?s=#{params[:message]}#{begin_str}#{finish_str}&g=d"
  puts uri
  stock = HTTParty.get("#{uri}")
  @stock_prices = {}
  info = stock.body.split("\n")
  info.delete_at(0)
  info.each do |line|
    individ_data = line.split(',')
   @stock_prices[individ_data[0]] = individ_data[-1].to_f.round(2)
  end
  "the post worked: #{params[:message]}"
  "Here is the info: #{@stock_prices}"
  erb :highcharts
end


get '/test' do
  erb :index
end
