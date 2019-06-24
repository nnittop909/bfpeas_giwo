module Employees
	class LogDetailsController < ApplicationController
		respond_to :html, :json

		def index
			@date = params[:date].present? ? Date.parse(params[:date]) : Date.today
			@employee = Employee.find(params[:employee_id])
			@am_ends_at   = DateTimeParser.new(@date, @employee.business_hour.am_ends).parse!
    	@pm_starts_at = DateTimeParser.new(@date, @employee.business_hour.pm_starts).parse!
    	@pm_ends_at   = DateTimeParser.new(@date, @employee.business_hour.pm_ends).parse!
    	@am_starts_at = DateTimeParser.new(@date, @employee.business_hour.am_starts).parse!
			@am_worked_times = @employee.worked_times.where(in_at: @date.beginning_of_day..@am_ends_at).order(:in_at)
			@pm_worked_times = @employee.worked_times.where(in_at: @am_ends_at..@pm_ends_at).order(:in_at)
			respond_modal_with @employee
		end
	end
end