module Employees
	class ImportsController < ApplicationController

		def create
			@employee_import = EmployeeImporter.new(import_params)
			@employee_import.parse_records!
			redirect_to request.referer, notice: "Employees importing complete."
		end

		private

		def import_params
			params.require(:employee_importer).permit(
				:spreadsheet_file, :school_id
			)
		end
	end
end