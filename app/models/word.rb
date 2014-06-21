class Word < ActiveRecord::Base
  has_many :occurrences
  has_many :articles, through: :occurrences
  has_many :sources, through: :occurrences
end
