namespace :keywords do
  desc 'fetch articles from all sources'
  task fetch: :environment do
    Source.all.map &:fetch!
  end

  desc 'index recently added and not indexed articles'
  task index: :environment do
    Article.newly.map { |a| a.parse!.index! }
  end
end
