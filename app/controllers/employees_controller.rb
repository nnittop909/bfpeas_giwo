class EmployeesController < ApplicationController
	respond_to :html, :json

	def index
		@departments = Department.all
		if params[:search].present?
    	@filtered_results = current_school.employees.search(params[:search]).sort_by(&:reversed_name)
      @employees = Kaminari.paginate_array(@filtered_results).page(params[:page]).per(30)
		else
			@filtered_results = current_school.employees.all.sort_by(&:reversed_name)
			@employees = Kaminari.paginate_array(@filtered_results).page(params[:page]).per(30)
		end
	end

	def new
		@employee = EmployeeProcessor.new
		respond_modal_with @employee
	end

	def create
		@employee = EmployeeProcessor.new(employee_params).process!
		respond_modal_with @employee,
			location: employees_url
	end

	def edit
		@employee = current_school.employees.find(params[:id])
		respond_modal_with @employee
	end

	def update
		@employee = current_school.employees.find(params[:id])
		@employee.update_attributes(update_params)
		respond_modal_with @employee,
			location: employee_url(@employee)
	end

	def show
		@employee = current_school.employees.find(params[:id])
	end

	private

	def employee_params
		params.require(:employee_processor).permit(
			:school_id,
			:role,
			:first_name,
			:middle_name,
			:last_name,
			:birthdate,
			:marital_status,
			:spouse_name,
			:alternate_email,
			:designation,
			:mobile_number,
			:sitio,
			:barangay,
			:municipality,
			:province,
			:id_number,
			:rfid_uid
		)
	end

	def update_params
		params.require(:employee).permit(
			:role,
			:first_name,
			:middle_name,
			:last_name,
			:birthdate,
			:marital_status,
			:spouse_name,
			:alternate_email,
			:designation
		)
	end
end