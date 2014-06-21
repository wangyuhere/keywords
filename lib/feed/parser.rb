require 'nokogiri'
require 'open-uri'

module Feed
  class Parser
    attr_reader :url, :doc, :text, :css

    def initialize(url, css)
      @url = url
      @css = css
      @doc = Nokogiri::HTML(open(url))
    end

    def text
      @text ||= elements_without_script.text.strip.gsub(/[\r\n\t\s]+/, ' ')
    end

    private

    def elements_without_script
      doc.css(css).tap do |e|
        e.search('script').each {|el| el.unlink}
      end
    end
  end
end
