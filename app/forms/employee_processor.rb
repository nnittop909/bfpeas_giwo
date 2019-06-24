class EmployeeProcessor
	include ActiveModel::Model
	attr_accessor :school_id, :first_name, :middle_name, :last_name, :birthdate, 
			:marital_status, :spouse_name, :alternate_email, :designation, :mobile_number,
			:role, :sitio, :barangay, :municipality, :province, :id_number, :rfid_uid

	def process!
		ActiveRecord::Base.transaction do
			employee = Employee.create(
				role:            role,
				school_id:       school_id,
				first_name:      first_name,
				middle_name:     middle_name,
				last_name:       last_name,
				birthdate:       birthdate,
				marital_status:  marital_status,
				spouse_name:     spouse_name,
				alternate_email: alternate_email,
				designation:     designation
			)
			create_contact(employee)
			create_address(employee)
			create_id_card(employee)
		end
	end

	def create_contact(employee)
		employee.contacts.create(
			number: mobile_number, 
			default: true
		)
	end

	def create_address(employee)
		employee.addresses.create(
			sitio:        sitio,
			barangay:     barangay,
			municipality: municipality,
			province:     province,
			default:      true
		)
	end

	def create_id_card(employee)
		employee.id_cards.create(
			id_number: id_number,
			rfid_uid:  rfid_uid,
			default:   true
		)
	end
end