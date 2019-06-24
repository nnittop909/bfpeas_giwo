class PositionTitle < ApplicationRecord

	enum placement: [:beginning_of_name, :end_of_name]
  belongs_to :employee

  validates :name, :placement, presence: true
  before_save :set_default

  def to_s
  	name
  end

  def default?
  	default == true
  end

  private
  def set_default
  	if default == true
  		employee.position_titles.each do |title|
  			title.update(default: false)
  		end
  	end
  end
end
