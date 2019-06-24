class IdCard < ApplicationRecord
  belongs_to :employee

  validates :id_number, :rfid_uid, presence: true
  validates :id_number, :rfid_uid, uniqueness: true
  before_save :set_default

  def default?
  	default == true
  end

  def self.default
  	where(default: true)
  end

  private
  def set_default
  	if default == true
  		employee.id_cards.each do |card|
  			card.update(default: false)
  		end
  	end
  end
end
