require 'phrases/count'
require 'phrases/rank'

module Phrases
  extend WithRedis

  def self.count_all
    count(1)
    grams.each { |gram| count gram }
  end

  def self.rank_all
    grams.each { |gram| Rank.new(gram).run }
  end

  def self.count(gram=2)
    key = "count_phrases_#{gram}_last_article_id"
    last_article_id = redis.get(key) || 0

    Article.indexed.where("id > ?", last_article_id).order('id asc').find_each do |a|
      redis.multi do
        Count.new(a.text, gram).run
        redis.set key, a.id
        puts "Counted article #{a.id}!"
      end
    end
  end

  def self.grams
    2..5
  end
end
