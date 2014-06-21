class CreateSources < ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.string :title
      t.string :url
      t.string :feed_url
      t.datetime :last_modified_at

      t.timestamps
    end
    add_index :sources, :last_modified_at
  end
end
