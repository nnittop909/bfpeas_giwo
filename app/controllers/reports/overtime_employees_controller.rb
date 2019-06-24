module Reports
	class OvertimeEmployeesController

		def index
			@date = params[:date].present? ? params[:date] : Date.today
			@employees = Employee.not_admin.overtime(@date)
			@title = "Overtimed"
			respond_to do |format|
        format.html
        format.pdf do
          pdf = Employees::AttendanceStatusPdf.new(employees: @employees, date: @date, title: @title)
          send_data pdf.render, type: "application/pdf", disposition: 'inline', file_name: "#{@title}.pdf"
        end
      end
		end
	end
end