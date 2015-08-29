class Church < ActiveRecord::Base
  attr_accessible :name
  has_many :presentations
  has_many :settings
  has_many :diapos
  has_many :users
  has_many :anniversaries

end
