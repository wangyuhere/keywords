class Word < ActiveRecord::Base
  has_many :occurrences
  has_many :articles, through: :occurrences
  has_many :sources, through: :occurrences

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
end
