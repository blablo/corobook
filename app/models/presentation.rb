class Presentation < ActiveRecord::Base
  attr_accessible :fecha, :contents_attributes
  has_many :contents, :order => 'position ASC'

 
  accepts_nested_attributes_for :contents

  
end

