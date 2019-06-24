class ReportsController < ApplicationController

	def index
		@date = params[:date].present? ? params[:date] : Date.today
		@from_date = params[:from_date].present? ? params[:from_date] : Date.today.beginning_of_month
		@to_date   = params[:to_date].present? ? params[:to_date] : Date.today.end_of_month
	end
end