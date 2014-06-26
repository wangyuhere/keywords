namespace :keywords do
  desc 'fetch articles from all sources'
  task fetch: :environment do
    count = 0
    Source.all.find_each do |s|
      s.fetch!
      count += 1
    end
    puts "Fetched from #{count} sources!"
  end

  desc 'index recently added and not indexed articles'
  task index: :environment do
    count = 0
    Article.newly.find_each do |a|
      a.parse!.index! rescue puts "#{a.to_s} can not be indexed!" and next
      count += 1
    end
    puts "Indexed #{count} articles!"
  end
end
