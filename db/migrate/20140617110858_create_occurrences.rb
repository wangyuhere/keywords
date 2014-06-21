class CreateOccurrences < ActiveRecord::Migration
  def change
    create_table :occurrences do |t|
      t.integer :word_id, null: false
      t.integer :article_id, null: false
      t.integer :source_id, null: false
    end
    add_index :occurrences, :word_id
    add_index :occurrences, :article_id
    add_index :occurrences, :source_id
  end
end
