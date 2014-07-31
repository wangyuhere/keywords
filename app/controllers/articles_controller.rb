class ArticlesController < ApplicationController
  def index
    page = params[:page] || 1
    @articles = Article.includes(:source).order('published_at desc').page(page).per(20)
  end

  def show
    @article = Article.find params[:id]
    @word = params[:word]
    fresh_when @article
  end
end
