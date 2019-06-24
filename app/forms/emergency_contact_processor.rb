class EmergencyContactProcessor
	include ActiveModel::Model
	attr_accessor :employee_id, :first_name, :middle_name, :last_name, :mobile_number,
								:relationship, :sitio, :barangay, :municipality, :province

	def initialize(attr={})
		if !attr["id"].nil?
			@employee = Employee.find(attr["id"])
			@emergency_contact = @employee.emergency_contact
			@contact   = @emergency_contact.current_contact
			@address   = @emergency_contact.current_address
			self.first_name = attr[:first_name].nil? ? @emergency_contact.first_name : attr[:first_name]
      self.middle_name = attr[:middle_name].nil? ? @emergency_contact.middle_name : attr[:middle_name]
      self.last_name = attr[:last_name].nil? ? @emergency_contact.last_name : attr[:last_name]
      self.mobile_number =  attr[:mobile_number].nil? ? @contact.try(:number) : attr[:mobile_number]

      self.relationship =  attr[:relationship].nil? ? @emergency_contact.relationship : attr[:relationship]
      self.sitio =  attr[:sitio].nil? ? @address.try(:sitio) : attr[:sitio]
      self.barangay =  attr[:barangay].nil? ? @address.try(:barangay) : attr[:barangay]
      self.municipality =  attr[:municipality].nil? ? @address.try(:municipality) : attr[:municipality]
      self.province =  attr[:province].nil? ? @address.try(:province) : attr[:province]
    else
      super(attr)
    end
	end

	def process!
		ActiveRecord::Base.transaction do
			emergency_contact = @employee.create_emergency_contact(
				first_name: first_name,
				middle_name: middle_name,
				last_name:   last_name,
				relationship: relationship
			)
			create_contact(emergency_contact)
			create_address(emergency_contact)
		end
	end

	def update!
		ActiveRecord::Base.transaction do
			emergency_contact = @emergency_contact.update(
				first_name: first_name,
				middle_name: middle_name,
				last_name:   last_name,
				relationship: relationship
			)
			@contact.nil? ? create_contact(emergency_contact) : update_contact(emergency_contact)
			@address.nil? ? create_address(emergency_contact) : update_address(emergency_contact)
		end
	end

	def create_contact(emergency_contact)
		emergency_contact.contacts.create(
			number: mobile_number, 
			default: true
		)
	end

	def update_contact(emergency_contact)
		@contact.update(
			number: mobile_number, 
			default: true
		)
	end

	def create_address(emergency_contact)
		emergency_contact.addresses.create(
			sitio:        sitio,
			barangay:     barangay,
			municipality: municipality,
			province:     province,
			default:      true
		)
	end

	def update_address(emergency_contact)
		@address.update(
			sitio:        sitio,
			barangay:     barangay,
			municipality: municipality,
			province:     province,
			default:      true
		)
	end
end