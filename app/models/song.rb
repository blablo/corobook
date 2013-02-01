class Song < ActiveRecord::Base
  attr_accessible :author, :link, :lyric, :mood, :order, :reference, :title, :user_id
  has_many :songbook_songs

  def in_songbook?(sbid)
    !self.songbook_songs.where('songbook_id = ?', sbid).empty?
  end
  def clean_lyric
    lines = self.lyric.split(/\n/)
    clean_lyric = ""
    prev_chords = false
    lines.each do |line|
      if line =~ /\b[CDEFGAB]m?7?\b/ and !prev_chords 
        prev_chords = true
      else
        prev_chords = false
        clean_lyric += line
      end
    end
    return clean_lyric
  end

end
