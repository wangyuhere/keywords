class WordsController < ApplicationController
  def index
    page = params[:page] || 1
    @words = Word.top_words page
  end

  def show
  end
end
