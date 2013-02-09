class Songbook < ActiveRecord::Base
  attr_accessible :title, :fecha
  has_many :songbook_songs
end
