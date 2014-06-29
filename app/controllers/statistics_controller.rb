class StatisticsController < ApplicationController
  def index
    @stats = StatisticsPresenter.new
  end
end
