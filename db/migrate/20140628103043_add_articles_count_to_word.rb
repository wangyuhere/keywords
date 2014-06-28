class AddArticlesCountToWord < ActiveRecord::Migration
  def change
    add_column :words, :articles_count, :integer, default: 0
    Word.reset_column_information
    Word.find_each do |w|
      Word.update_counters w.id, :articles_count => w.articles.count
    end
    add_index :words, :articles_count
  end
end
