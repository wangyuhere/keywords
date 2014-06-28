module ArticlesHelper
  def highlight_word(body, word)
    return body unless word.present?
    body.gsub(" #{word} ", "<span class='highlight'> #{word} </span>").html_safe
  end
end
