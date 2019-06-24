class EmployeeInformationPdf < Prawn::Document
	TABLE_COLUMNS = [121, 160, 121, 160]
	def initialize(args={})
    super(margin: [40, 25, 25, 25], page_size: [612, 876], page_layout: :portrait) #[562, 786]
    @employee = args[:employee]
    header
    body
    footer
  end

  def header
  	bounding_box [0, 786], width: 161 do
      # stroke_bounds
      image "#{Rails.root}/app/assets/images/ia_logo.png", width: 70, height: 70, position: :right
    end
    bounding_box [161, 786], width: 240 do
      # stroke_bounds
      font("#{Rails.root}/app/assets/fonts/Invitation-Regular.ttf") do
      	text "United Church of Christ in the Philippines", size: 14, align: :center
     	end
     	move_down 4
     	font("#{Rails.root}/app/assets/fonts/BroadwayBT.ttf") do
      	text "THE IFUGAO ACADEMY", size: 15, align: :center
      end
      move_down 4
      text '<i>Bulayugan St. cor. Metzger Rd.</i>', size: 13, align: :center, inline_format: true
      text "Kiangan, Ifugao", size: 13, align: :center
      move_down 3
      text "<i>Member: UCCP-CREATE</i>", size: 9, align: :center, inline_format: true
      text "<i>Cordillera Schools Group</i>", size: 9, align: :center, inline_format: true
      text "<i>Association of Christian Schools Colleges and Universities</i>", size: 9, align: :center, inline_format: true

    end
    bounding_box [401, 786], width: 161 do
      # stroke_bounds
      # image "#{Rails.root}/app/assets/images/church_logo.jpg", width: 70, height: 70
    end
    move_down 10
    text "EMPLOYEE BASIC INFORMATION SHEET", style: :bold, size: 17, align: :center
    stroke do
      stroke_color '000000'
      line_width 3
      stroke_horizontal_rule
      move_down 8
    end
  end

  def body
  	if @employee.avatar.attached?
      image StringIO.open(@employee.avatar.download), width: 140, height: 140, position: :center
      # image "#{Rails.root}/app/storage/#{@employee.avatar.key.first(2)}/#{@employee.avatar.key.first(4).last(2)}/#{@employee.avatar.key}", width: 140, height: 140, position: :center
    else
    	image "#{Rails.root}/app/assets/images/default.png", width: 140, height: 140, position: :center
    end
    move_down 5
    basic_info_header
    basic_info_data
    emergency_contact_info_header
    emergency_contact_info_data
    
  end

  def basic_info_header
  	table_data ||= [{content: "EMPLOYEE INFORMATION", colspan: 4, font_style: :bold}]
  	table([table_data], column_widths: TABLE_COLUMNS,
      cell_style: { size: 13, font_style: :bold, font: "Helvetica", :background_color => "edeff1", 
      	inline_format: true, :padding => [6, 2, 6, 2]
      }) do
  		row(0).align = :center
    end
  end

  def basic_info_data
  	table_data ||= [["Full Name:", {content: @employee.reversed_fullname, colspan: 3}]] +
  	[["Address:", {content: @employee.current_address.full_details, colspan: 3}]] +
  	[["Phone Number:", @employee.current_contact.number, "Birth Date:", ""]] +
  	[["Marital Status:", @employee.marital_status.titleize, "Spouse Name:", ""]] +
  	[["Email Address:", {content: @employee.email, colspan: 3}]] +
  	[["PRC License Number:", "", "SSS Number", ""]] +
  	[["PAGIBIG Number:", "", "Phil Health Number:", ""]]
  	table(table_data, column_widths: TABLE_COLUMNS,
      cell_style: { size: 13, font: "Helvetica", inline_format: true, :padding => [4, 4, 4, 4]}) do
      column(1).font_style = :bold
      column(3).font_style = :bold
    end
  end

  def emergency_contact_info_header
  	table_data ||= [{content: "EMERGENCY CONTACT INFORMATION", colspan: 4, font_style: :bold}]
  	table([table_data], column_widths: TABLE_COLUMNS,
      cell_style: { size: 13, font_style: :bold, font: "Helvetica", :background_color => "edeff1", 
      	inline_format: true, :padding => [6, 2, 6, 2]
      }) do
  		row(0).align = :center
    end
  end

  def emergency_contact_info_data
  	table_data ||= [["Full Name:", {content: @employee.reversed_fullname, colspan: 3}]] +
  	[["Address:", {content: @employee.current_address.full_details, colspan: 3}]] +
  	[["Phone Number:", @employee.current_contact.number, "Relationship:", ""]]

  	table(table_data, column_widths: TABLE_COLUMNS,
      cell_style: { size: 13, font: "Helvetica", inline_format: true, :padding => [4, 4, 4, 4]}) do
      column(1).font_style = :bold
      column(3).font_style = :bold
    end
  end

  def footer
  	bounding_box [106, 50], width: 350 do
      # stroke_bounds
      stroke do
	      stroke_color '000000'
	      horizontal_rule
	      line_width 1
	    end
	    move_down 3
      text "<i>Signature Over Printed Name</i>", size: 10, align: :center, inline_format: true
    end
  end
end