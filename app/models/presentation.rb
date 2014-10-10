class Presentation < ActiveRecord::Base
  attr_accessible :fecha, :contents_attributes
  has_many :contents, :order => 'position ASC', :dependent => :destroy

 
  accepts_nested_attributes_for :contents, :reject_if => lambda { |a| a[:song_id].empty? and a[:diapo_id].empty? }, :allow_destroy => true

  validates :fecha, presence: true
  
end

