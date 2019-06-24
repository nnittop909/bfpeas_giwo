class DailyTimeRecordPdf < Prawn::Document
  TABLE_COLUMNS = [28, 35, 42, 2, 35, 42, 2, 35, 35]
	def initialize(args={})
    super(margin: [25, 25, 25, 25], page_size: [612, 792], page_layout: :portrait)
    @employee = args[:employee]
    @date = args[:date]
    @signatory = args[:signatory]
    @regular_days = RegularDays.new(@date).count!
    @saturdays = SaturdaysPlucker.new(@date).pluck!.count
    body
    # footer
  end

  def body # width = 876
  	bounding_box([0,742], :width => 256, :height => 742) do
      # stroke_bounds
      header
      content1
      text content2, size: 10, align: :justify, inline_format: true
      content3
      table_body
      text certification_first_line, size: 8, inline_format: true, :indent_paragraphs => 30
      text certification_second_to_last_line, size: 8, inline_format: true
      divider
      incharge
    end
    bounding_box([306,742], :width => 256, :height => 742) do
      # stroke_bounds
      header
      content1
      text content2, size: 10, align: :justify, inline_format: true
      content3
      table_body
      text certification_first_line, size: 8, inline_format: true, :indent_paragraphs => 30
      text certification_second_to_last_line, size: 8, inline_format: true
      divider
      incharge
    end
  end

  def header
    text "Civil Service Form No. 148", style: :italic, size: 8
    move_down 15
    text "DAILY TIME RECORD", style: :bold, size: 16, align: :center
    stroke do
      stroke_color '000000'
      line_width 2
      horizontal_line 103, 153, :at => 700
      move_down 10
    end
    text @employee.full_name, size: 12, align: :center, style: :bold
    stroke do
      stroke_color '000000'
      line_width 1
      stroke_horizontal_rule
      move_down 3
    end
    text "(Name)", style: :italic, size: 10, align: :center
    move_down 8
  end
  def content1
    table_data = [["<i>For the month of</i>", "<u><font size='12'>#{@date.strftime('%B')}</font></u>", ",", "<u><font size='12'>#{@date.year}</font></u>"]]
    table(table_data, column_widths: [90, 120, 5, 40],
      cell_style: { size: 10, font: "Helvetica", inline_format: true, :padding => [4, 0, 4, 0]}) do
      cells.borders = []
      column(1).align = :right
      column(2).align = :right
      column(3).align = :right
      row(0).valign = :center
    end
  end
  def content2 
    "<i>Official hours of arrival and departure.</i>"
  end
  def content3
    table_data = [["Regular Days", "<font size='12'>#{@regular_days}</font>", "Saturdays", "<font size='12'>#{@saturdays}</font>"]]
    table(table_data, column_widths: [70, 75, 70, 40],
      cell_style: { size: 10, font: "Helvetica", inline_format: true, :padding => [4, 0, 4, 0]}) do
      cells.borders = []
      column(2).align = :right
      column(3).align = :right
      row(0).valign = :center
    end
    move_down 5
  end
  def table_header1
    [
      {content: "Days", rowspan: 2, font_style: :bold, size: 11, valign: :center}, 
      {content: "A.M.", colspan: 2, font_style: :bold, size: 11}, "", 
      {content: "P.M.", colspan: 2, font_style: :bold, size: 11}, "", 
      {content: "Under Time", colspan: 2, font_style: :bold, size: 11}
    ]
  end
  def table_header2
    [
      {content: "Arrival", size: 7}, 
      {content: "Departure", size: 7}, "", 
      {content: "Arrival", size: 7}, 
      {content: "Departure", size: 7}, "", 
      {content: "Hours", size: 7}, 
      {content: "Minutes", size: 7}
    ]
  end
  def table_body
    table_data = Time.days_in_month(@date.month, @date.year).times.map do |day|
      number = day + 1
      parsed_date = Date.new(@date.year, @date.month, (number))
      daily_time_records = @employee.daily_time_records(parsed_date)
      if daily_time_records.present?
        [
          number, 
          @employee.dtr_am_in(parsed_date).present? ? @employee.dtr_am_in(parsed_date).logged_at.strftime('%I:%M') : "-",
          @employee.dtr_am_out(parsed_date).present? ? @employee.dtr_am_out(parsed_date).logged_at.strftime('%I:%M') : "-",
          "",
          @employee.dtr_pm_in(parsed_date).present? ? @employee.dtr_pm_in(parsed_date).logged_at.strftime('%I:%M') : "-",
          @employee.dtr_pm_out(parsed_date).present? ? @employee.dtr_pm_out(parsed_date).logged_at.strftime('%I:%M') : "-",
          "",
          UndertimeCalculator.new(parsed_date, @employee).get_hours.to_i.zero? ? "-" : UndertimeCalculator.new(parsed_date, @employee).get_hours,
          UndertimeCalculator.new(parsed_date, @employee).get_minutes.to_i.zero? ? "-" : UndertimeCalculator.new(parsed_date, @employee).get_minutes
        ]
      else
        [number, "-", "-", "", "-", "-", "", "-", "-"]
      end
    end
    table([table_header1, table_header2, *table_data], column_widths: TABLE_COLUMNS,
      cell_style: { align: :center, size: 9, font: "Helvetica", inline_format: true, :padding => [0, 0, 2, 0]}) do
    end
    table_footer
  end

  def table_footer
    table_data = [[
      {content: "TOTAL", colspan: 2, align: :right, font_style: :bold}, 
      {content: TotalWorkedCalculator.new(@date, @employee).worked_in_words, colspan: 4, align: :right}, "", 
      TotalUndertimeCalculator.new(@date, @employee).get_hours,
      TotalUndertimeCalculator.new(@date, @employee).get_minutes
    ]]
    table(table_data, column_widths: TABLE_COLUMNS,
      cell_style: { size: 9, font: "Helvetica", inline_format: true, :padding => [3, 2, 3, 0]}) do
        column(7).align = :center
        column(8).align = :center
    end
    stroke do
      move_down 3
      stroke_color '000000'
      line_width 2
      stroke_horizontal_rule
      move_down 5
    end
  end

  def certification_first_line
    move_down 5
    "<i>I CERTIFY on my honor that the above is a true and correct</i>"
  end

  def certification_second_to_last_line
    "<i>report of the hours of work performed, record of which was made
    daily at the time of arrival and departure from office.</i>"
  end

  def divider
    move_down 15
    table_data = [[""]]
    table(table_data, position: :right, column_widths: [163],
      cell_style: { size: 9, font: "Helvetica", inline_format: true, :padding => [0, 0, 2, 0]}) do
        cells.borders = [:bottom]
    end
    move_down 3
    stroke do
      stroke_color '000000'
      line_width 2
      stroke_horizontal_rule
      move_down 30
    end
  end

  def incharge
    table_data = [[@signatory]]
    table(table_data, position: :right, column_widths: [163],
      cell_style: { size: 11, font: "Helvetica", inline_format: true, :padding => [0, 0, 2, 0]}) do
        cells.borders = [:bottom]
        row(0).align = :center
        row(0).font_style = :bold
    end
    move_down 2
    text "In-Charge", style: :italic, size: 10, inline_format: true, :indent_paragraphs => 155
  end
end