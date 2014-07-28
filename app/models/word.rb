class Word < ActiveRecord::Base
  has_many :occurrences, dependent: :delete_all
  has_many :articles, -> { uniq }, through: :occurrences
  has_many :sources, -> { uniq }, through: :occurrences

  def self.update_all_occurrences_count
    Word.find_each do |w|
      w.update_occurrences_count
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

  def self.top_words(search, page=1, per=100)
    query = order('occurrences_count desc')
    query = query.where('name like ?', search+'%') if search.present?
    query.page(page).per(per)
  end

  def self.words_of_day(date=Date.yesterday, limit=30)
    range = (date.beginning_of_day)..(date.end_of_day)
    words = Occurrence.select('word_id, count(*) as count').joins(:article).where("articles.published_at #{range.to_s(:db)}").group(:word_id).order('count desc').limit(1000)
    ids = words.map(&:word_id) - Word.order('occurrences_count desc').limit(1000).pluck(:id)
    Word.where(id:ids).order('occurrences_count desc').limit(limit/2) + Word.where(id:ids).order('occurrences_count').limit(limit/2)
  end

  def update_occurrences_count
    Word.update_counters id, occurrences_count: occurrences.count - occurrences_count
  end
end
