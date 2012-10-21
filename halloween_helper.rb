require 'sinatra'
require 'wikipedia'
require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require './db/models/article'

configure :development, :test do
  set :database, 'postgres:///halloween_helper'
end

configure :production do
  db = URI.parse(ENV['DATABASE_URL'])
  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end

configure :production do
  require 'newrelic_rpm'
end

# Homepage
get '/' do
  @article = Article.order("number_of_votes DESC").first || Article.create_from_wikipedia!
  haml :result
end

get '/about' do
  haml :about
end

get '/articles' do
  @articles = Article.where("number_of_votes > 0").order("number_of_votes DESC").limit(10)
  haml :top
end

get '/articles/:article_id' do
  article_id = params[:article_id]
  @article = Article.find_by_id(article_id)
  haml :result
end

post '/' do
  @article = Article.create_from_wikipedia!
  haml :result
end

post '/articles/:article_id/votes' do
  @article = Article.find(params[:article_id])
  @article.update_attribute :number_of_votes, @article.number_of_votes + 1
  haml :result
end