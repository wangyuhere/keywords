namespace :keywords do
  desc 'fetch articles from all sources'
  task fetch: :environment do
    count = 0
    Source.all.find_each do |s|
      s.fetch!
      count += 1
    end
    puts "Fetching from #{count} sources ..."

    count = 0
    Article.newly.find_each do |a|
      a.parse! rescue puts "#{a.to_s} can not be fetched!" and next
      count += 1
    end
    puts "Fetched #{count} new articles!"
  end

  desc 'index recently added and not indexed articles'
  task index: :environment do
    count = 0
    Article.ready_to_index.find_each do |a|
      a.index!
      count += 1
    end
    puts "Indexed #{count} articles!"
  end

  desc 'fetch and index'
  task import: [:fetch, :index] do
    puts "Imported at #{Time.now}"
  end

  desc 'count phrases'
  task count_phrases: :environment do
    require 'analyze/phrases'
    gram = (ENV['GRAM'] || 2).to_i
    key = "count_phrases_#{gram}_last_article_id"
    redis = Redis.current
    last_article_id = redis.get(key) || 0

    Article.indexed.where("id > ?", last_article_id).order('id asc').find_each do |a|
      redis.multi do
        Analyze::Phrases.new(a.text, gram).count!
        redis.set key, a.id
        puts "Counted article #{a.id}!"
      end
    end
  end

  desc 'rank phrases'
  task rank_phrases: :environment do
    require 'analyze/phrases_rank'
    gram = (ENV['GRAM'] || 2).to_i
    Analyze::PhrasesRank.new(gram).run
  end
end
