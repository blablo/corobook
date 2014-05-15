class Content < ActiveRecord::Base
  attr_accessible :diapo_id, :order, :presentation_id, :song_id
  belongs_to :presentation
  belongs_to :song

end
