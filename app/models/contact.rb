class Contact < ApplicationRecord
  belongs_to :contactable, polymorphic: true
  validates :number, presence: true
  before_save :set_default

  def default?
  	default == true
  end

  private
  def set_default
  	if default == true
  		contactable.contacts.each do |contact|
  			contact.update(default: false)
  		end
  	end
  end
end
