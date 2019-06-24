class EmployeeImporter
	require 'roo'
	include ActiveModel::Model

	attr_accessor :spreadsheet_file, :school_id

  def parse_records!
    employee_spreadsheet = Roo::Spreadsheet.open(spreadsheet_file.path)
    header = employee_spreadsheet.row(4)
    (5..employee_spreadsheet.last_row).each do |i|
      row = Hash[[header, employee_spreadsheet.row(i)].transpose]
      ActiveRecord::Base.transaction do 
        find_or_create_employee(row)
      end
    end
  end

  def find_or_create_employee(row)
    employee = find_school.employees
    .where(first_name: row['First Name'])
    .where(last_name: row['Last Name'])
    .where(last_name: row['Middle Name']).first_or_create! do |e|
      e.role             = row["Employee Type"].downcase.split(" ").join("_")
      e.birthdate        = Date.parse(row["Birth Date"].to_s)
      e.marital_status   = row['Marital Status'].downcase.split(" ").join("_")
      e.spouse_name      = row["Spouse Name"]
      e.email            = row["Email Address"]
      e.school_id        = school_id
    end
    create_contact(row, employee)
    create_address(row, employee)
    create_license_and_insurance(row, employee)
    create_emergency_contact(row, employee)
  end

  def create_contact(row, employee)
    employee.contacts.create(
      number: row['Phone Number'], 
      default: true
    )
  end

  def create_address(row, employee)
    employee.addresses.create(
      sitio:        row["Sitio"],
      barangay:     row["Barangay"],
      municipality: row["Municipality"],
      province:     row["Province"],
      default:      true
    )
  end

  def create_license_and_insurance(row, employee)
    employee.create_license_and_insurance(
      prc_license_number: row["PRC License Number"],
      pagibig_number:     row["PAGIBIG Number"],
      sss_number:         row["SSS Number"],
      phil_health_number: row["Phil Health Number"]
    )
  end

  def create_emergency_contact(row, employee)
    emergency_contact = employee.create_emergency_contact(
      first_name:     row["EC First Name"],
      middle_name:    row["EC Middle Name"],
      last_name:      row["EC Last Name"],
      relationship:   row["Relationship"]
    )
    emergency_contact.contacts.create(
      number: row['EC Phone Number'], 
      default: true
    )
    emergency_contact.addresses.create(
      sitio:        row["EC Sitio"],
      barangay:     row["EC Barangay"],
      municipality: row["EC Municipality"],
      province:     row["EC Province"],
      default:      true
    )
  end

  private

  def find_school
    School.find(school_id)
  end
end