class Presentation < ActiveRecord::Base
  attr_accessible :fecha, :contents_attributes
  has_many :contents
  
  accepts_nested_attributes_for :contents
  
end
