class Content < ActiveRecord::Base
  attr_accessible :diapo_id, :order, :presentation_id, :song_id
  belongs_to :presentation
  belongs_to :song
  belongs_to :diapo
  belongs_to :todo_list
  acts_as_list scope: :presentation

  def thing
    if self.song
      return song
    else
      return diapo
    end
  end

end
