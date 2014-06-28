class WordsController < ApplicationController
  def index
    page = params[:page] || 1
    @words = Word.top_words page
  end

  def show
    page = params[:page] || 1
    @word = WordPresenter.new Word.find(params[:id]), page
  end
end
