require 'sinatra'
require 'wikipedia'
require 'json'
require 'sinatra'
require 'sinatra/activerecord'
require './db/models/article'

set :database, 'postgres:///halloween_helper'

configure :production do
  require 'newrelic_rpm'
end

# Homepage
get '/' do
  @article = Article.order("number_of_votes DESC").first
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
  @article = Article.find_by_id(article_id) || Article.new do |article|
    article.id = article_id
    article.title = article_data["title"]
    article.save!
  end
  haml :result
end

post '/' do
  article_result = Wikipedia::Client.new.request('action' => 'query', 'list' => 'random', 'rnnamespace' => '0')
  article_data = JSON.parse(article_result)["query"]["random"].first
  article_id = article_data["id"]
  @article = Article.find_by_id(article_id) || Article.new do |article|
    article.id = article_id
    article.title = article_data["title"]
    article.save!
  end
  haml :result
end

post '/articles/:article_id/votes' do
  @article = Article.find(params[:article_id])
  @article.update_attribute :number_of_votes, @article.number_of_votes + 1
  haml :result
end