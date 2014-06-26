class AddOccurrencesCountToWord < ActiveRecord::Migration
  def change
    add_column :words, :occurrences_count, :integer, default: 0
    Word.reset_column_information
    Word.find_each do |w|
      Word.update_counters w.id, :occurrences_count => w.occurrences.count
    end
  end
end
