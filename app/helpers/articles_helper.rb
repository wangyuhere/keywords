module ArticlesHelper
  def highlight_word(body, word)
    return body unless word.present?
    body.gsub(/(\W|\A)#{word}(\W|\Z)/i, "\\1<span class='highlight'>#{word}</span>\\2").html_safe
  end
end
