class Songbook < ActiveRecord::Base
  attr_accessible :title, :fecha
  has_many :songbook_songs
  has_many :songs, :through => :songbook_songs
end
