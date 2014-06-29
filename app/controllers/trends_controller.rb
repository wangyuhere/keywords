class TrendsController < ApplicationController
  def index
    @trends = TrendsPresenter.new params[:word_id]
  end
end
