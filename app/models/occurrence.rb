class Occurrence < ActiveRecord::Base
  belongs_to :word
  belongs_to :article
  belongs_to :source

  before_create :set_source

  protected

  def set_source
    self.source_id = article.source_id
  end
end
