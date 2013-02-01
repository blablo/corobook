class SongbookSong < ActiveRecord::Base
  attr_accessible :order, :song_id, :songbook_id
  validate :repeated_song
  belongs_to :song
  belongs_to :songbook

  def repeated_song
    self.errors[:base] << "mal" unless SongbookSong.where(:songbook_id => self.songbook_id, :song_id => self.song_id).empty?
  end

end
