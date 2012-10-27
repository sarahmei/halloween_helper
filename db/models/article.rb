class Article < ActiveRecord::Base
  validates_presence_of :title

  def self.create_from_wikipedia!
    article_result = Wikipedia::Client.new.request('action' => 'query', 'list' => 'random', 'rnnamespace' => '0')
    article_data = JSON.parse(article_result)["query"]["random"].first
    article_id = article_data["id"]
    Article.find_by_id(article_id) || Article.new do |article|
      article.id = article_id
      article.title = article_data["title"]
      article.save!
    end
  end

  def url
    "http://halloween-helper.herokuapp.com/articles/#{id}"
  end
end