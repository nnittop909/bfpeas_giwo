class ApplicationController < ActionController::Base
	include Pundit
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  before_action :authenticate_employee!
  rescue_from Pundit::NotAuthorizedError, with: :permission_denied

  helper_method :current_school, :non_working_days, :saturdays
  
  private

  def after_sign_in_path_for(current_user)
    employees_url
  end

  def current_school
  	current_employee.school
  end

  def non_working_days(date)
    (SundaysPlucker.new(date).pluck!.map{|d| d.day}) + (HolidaysPlucker.new(date).pluck!.map{|d| d.day})
  end

  def saturdays(date)
    SaturdaysPlucker.new(date).pluck!.map{|d| d.day}
  end

  def respond_modal_with(*args, &blk)
    options = args.extract_options!
    options[:responder] = ModalResponder
    respond_with *args, options, &blk
  end

  def permission_denied
    redirect_to "/", alert: 'Sorry, you are not allowed to access this page.'
  end
end
