require 'sinatra'
require 'wikipedia'
require 'json'

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

post '/' do
  article_result = Wikipedia::Client.new.request('action' => 'query', 'list' => 'random', 'rnnamespace' => '0')
  article_data = JSON.parse(article_result)["query"]["random"].first
  @article_title = article_data["title"]
  @article_url = "http://en.wikipedia.org/wiki/#{@article_title}"
  erb :result 
end

