require 'sinatra'

get '/' do
  erb :index
end

get '/about' do
  erb :about
end

post '/' do
  @article_title = "Charing Cross Station"
  @article_url = "http://en.wikipedia.org/wiki/Charing_Cross_Station"
  erb :result 
end

