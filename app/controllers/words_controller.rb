class WordsController < ApplicationController
  def index
    page = params[:page] || 1
    search = params[:search] || ''
    @words = Word.top_words search, page
  end

  def show
    page = params[:page] || 1
    @word = WordPresenter.new Word.find(params[:id]), page
  end
end
