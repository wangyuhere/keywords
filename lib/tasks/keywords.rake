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
  task all: [:fetch, :index] do
    puts 'Done!'
  end
end
