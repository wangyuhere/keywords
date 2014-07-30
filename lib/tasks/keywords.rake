namespace :keywords do
  desc 'fetch articles from all sources'
  task fetch: :environment do
    count = 0
    articles_count = 0
    Source.all.find_each do |s|
      articles_count += s.fetch!
      count += 1
    end
    puts "Checked #{count} sources and #{articles_count} new articles are found. Fetching ..."

    count = 0
    Article.newly.find_each do |a|
      ArticleParser.new(a).parse! rescue puts "#{a.to_s} can not be fetched!" and next
      count += 1
    end
    puts "Fetched #{count} new articles!"
  end

  desc 'index recently added and not indexed articles'
  task index: :environment do
    count = 0
    Article.ready_to_index.find_each do |a|
      ArticleIndexer.new(a).index!
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
    require 'phrases'
    Phrases.count_all
  end

  desc 'rank phrases'
  task rank_phrases: :environment do
    require 'phrases'
    Phrases.rank_all
  end
end
