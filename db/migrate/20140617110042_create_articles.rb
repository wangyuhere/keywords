class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body
      t.string :url
      t.integer :source_id, null: false
      t.datetime :published_at, null: false
      t.datetime :indexed_at

      t.timestamps
    end
    add_index :articles, :source_id
  end
end
