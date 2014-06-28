class AddIndexToArticles < ActiveRecord::Migration
  def change
    add_index :articles, :published_at
    add_index :articles, :indexed_at
  end
end
