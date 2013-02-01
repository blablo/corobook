class Songbook < ActiveRecord::Base
  attr_accessible :title
  has_many :songbook_songs
end
