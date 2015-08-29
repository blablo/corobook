class Anniversary < ActiveRecord::Base
  attr_accessible :category, :church_id, :date, :name

  validates :category, presence: true
  validates :name, presence: true

end
