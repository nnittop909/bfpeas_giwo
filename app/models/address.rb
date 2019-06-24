class Address < ApplicationRecord
	belongs_to :addressable, polymorphic: true
	validates :barangay, :municipality, :province, presence: true
	before_save :set_full_details, :set_default

	def default?
		default == true
	end

	private
	def set_full_details
		if sitio.present?
			self.full_details = "#{sitio}, #{barangay}, #{municipality}, #{province}"
		else
			self.full_details = "#{barangay}, #{municipality}, #{province}"
		end
	end

  def set_default
  	if default == true
  		addressable.addresses.each do |address|
  			address.update(default: false)
  		end
  	end
  end
end
