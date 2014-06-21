namespace :keywords do
  desc 'fetch articles from all sources'
  task fetch: :environment do
    Source.all.find_each &:fetch!
  end

  desc 'index recently added and not indexed articles'
  task index: :environment do
    Article.newly.find_each { |a| a.parse!.index! }
  end
end
