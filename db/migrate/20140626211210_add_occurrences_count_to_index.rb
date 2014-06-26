class AddOccurrencesCountToIndex < ActiveRecord::Migration
  def change
    add_index :words, :occurrences_count
  end
end
