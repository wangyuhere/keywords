require 'feed/parser'

class ArticleParser
  attr_reader :article

  def initialize(article)
    @article = article
  end

  def parse!
    article.tap do |a|
      a.body = parser.text
      a.save!
    end
  end

  private

  def parser
    @parser ||= Feed::Parser.new article.url, article.source.css_selector
  end
end
