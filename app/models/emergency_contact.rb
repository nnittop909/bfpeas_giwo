class EmergencyContact < ApplicationRecord
  belongs_to :employee
  has_many   :addresses, as: :addressable
  has_many   :contacts, as: :contactable
  before_save :set_full_name

  def current_address
    addresses.last
  end

  def current_contact
    contacts.last
  end

  private
  def set_full_name
  	fname = "#{first_name.titleize}"
  	mname = middle_name.present? ? "#{middle_name.first.upcase}." : nil
  	lname = "#{last_name.titleize}"
    self.full_name =  [fname, mname, lname].compact.join(" ")
  end
end
