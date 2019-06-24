class AttendanceSummaryPdf < Prawn::Document
  TABLE_COLUMNS = [170, 55, 55, 55, 2, 55, 55, 2, 55, 55]
	def initialize(args={})
    super(margin: [25, 25, 25, 25], page_size: [612, 876], page_layout: :portrait) #[562, 826]
    @employees = args[:employees]
    @date = args[:date]
    @title = args[:title]
    header
    body
    # footer
  end

  def header
    bounding_box [320, 826], width: 50 do
      # stroke_bounds
      # image "#{Rails.root}/app/assets/images/ia_logo.jpg", width: 40, height: 40
    end
    bounding_box [370, 826], width: 180 do
      # stroke_bounds
      text "The Ifugao Accademy", style: :bold, size: 16
      text "Bulayugan St. cor. Metzger Rd.", size: 10
      text "Kiangan, Ifugao", size: 10
    end
    bounding_box [0, 826], width: 420 do
      # stroke_bounds
      text "Attendance Summary", style: :bold, size: 14
      move_down 5
      text "For the month of <b>#{@date.strftime("%B, %Y")}</b>", size: 10, inline_format: true
      move_down 5
    end
    move_down 10
    stroke do
      stroke_color 'CCCCCC'
      line_width 0.2
      stroke_horizontal_rule
      move_down 15
    end
  end

  def body # width = 876
    if @employees.present?
      table_data = @employees.map do |employee|
        [
          employee.full_name, 
          TotalWorkedCalculator.new(@date, employee).get_days.to_i.zero? ? "-" : TotalWorkedCalculator.new(@date, employee).get_days,
          TotalWorkedCalculator.new(@date, employee).get_hours.to_i.zero? ? "-" : TotalWorkedCalculator.new(@date, employee).get_hours,
          TotalWorkedCalculator.new(@date, employee).get_minutes.to_i.zero? ? "-" : TotalWorkedCalculator.new(@date, employee).get_minutes,
          "",
          employee.dtr_monthly_total(@date).get_undertime_hours.to_i.zero? ? "-" : employee.dtr_monthly_total(@date).get_undertime_hours,
          employee.dtr_monthly_total(@date).get_undertime_minutes.to_i.zero? ? "-" : employee.dtr_monthly_total(@date).get_undertime_minutes,
          "",
          TotalOvertimeCalculator.new(@date, employee).get_hours.to_i.zero? ? "-" : TotalOvertimeCalculator.new(@date, employee).get_hours,
          TotalOvertimeCalculator.new(@date, employee).get_minutes.to_i.zero? ? "-" : TotalOvertimeCalculator.new(@date, employee).get_minutes
        ]
      end
    	table([table_header1, table_header2, *table_data], column_widths: TABLE_COLUMNS,
        cell_style: { align: :center, size: 9, font: "Helvetica", inline_format: true, :padding => [2, 0, 4, 2]}) do
        column(0).align = :left
      end
    else
      text "No Data.", align: :center, size: 11
    end
  end

  def table_header1
    [
      {content: "Employee", rowspan: 2, font_style: :bold, size: 11, valign: :center}, 
      {content: "Worked", colspan: 3, font_style: :bold, size: 11}, "", 
      {content: "Under Time", colspan: 2, font_style: :bold, size: 11}, "",
      {content: "Over Time", colspan: 2, font_style: :bold, size: 11}
    ]
  end

  def table_header2
    [ 
      {content: "Days", size: 7},
      {content: "Hours", size: 7}, 
      {content: "Minutes", size: 7}, "", 
      {content: "Hours", size: 7}, 
      {content: "Minutes", size: 7}, "",
      {content: "Hours", size: 7}, 
      {content: "Minutes", size: 7}
    ]
  end
end