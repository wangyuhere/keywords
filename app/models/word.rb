class Word < ActiveRecord::Base
  has_many :occurrences, dependent: :delete_all
  has_many :articles, -> { uniq }, through: :occurrences
  has_many :sources, -> { uniq }, through: :occurrences

  def self.update_all_occurrences_count
    Word.find_each do |w|
      Word.update_counters w.id, occurrences_count: w.occurrences.count - w.occurrences_count
    end
  end

  # Return array of word ids of the names passed in
  # If word doesn't exist for a name, create the word.
  # Ids are returned as the same order of the names
  def self.find_or_create_ids(names)
    uniq_names = names.uniq
    word_hash = Word.where(name: uniq_names).inject({}) { |h, w| h[w.name] = w.id; h }
    new_names = uniq_names - word_hash.keys
    if new_names.present?
      massive_insert_names new_names
      Word.where(name: new_names).inject(word_hash) { |h, w| h[w.name] = w.id; h}
    end
    names.map { |n| word_hash[n] }
  end

  def self.massive_insert_names(names)
    now = Time.now.to_s
    values = names.map { |n| "('#{n}','#{now}','#{now}')" }
    Word.connection.execute "INSERT INTO words (name, created_at, updated_at) VALUES #{values.join(',')}"
  end

  def self.top_words(page=1, per=100)
    order('occurrences_count desc').page(page).per(per)
  end
end
