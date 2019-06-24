module EmployeeUsers
	class SessionsController < Devise::SessionsController
	  layout 'signin'
	  skip_before_action :authenticate_employee!, only: [:new]

	  def new
	  	super
	  end
	end
end