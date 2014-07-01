class DaysController < ApplicationController
  def index
    first_date = Date.parse '2014-06-20'
    @date_range = (Date.yesterday).downto first_date
  end

  def show
    date = Date.parse(params[:date]) rescue redirect_to(days_path, alert: "#{params[:date]} is not a correct date!") && return
    @words = Word.words_of_day date
  end
end
