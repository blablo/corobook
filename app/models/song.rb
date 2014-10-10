# -*- coding: utf-8 -*-
class Song < ActiveRecord::Base
  attr_accessible :author, :link, :lyric, :mood, :order, :reference, :title, :user_id
  has_many :songbook_songs
  has_many :songbooks, :through => :songbook_songs
  has_many :votes

  validates :title, presence: true
  validates :lyric, presence: true
  validates :order, presence: true
  validate :validate_sintax

  def validate_sintax
    if self.lyric.scan(/\[.*\]/i).blank?
      errors.add(:order, "No se encontraron versos en el texto. Ej: [CORO] ")
    end
    
  end

 
  def expiration_date_cannot_be_in_the_past
    if expiration_date.present? && expiration_date < Date.today
      errors.add(:expiration_date, "can't be in the past")
    end
  end



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

  def diapo_mode(chords=false)
    versos = self.lyric.scan(/\[.*\]/i)
    hash = { }
    hash_actual = ''
    is_chord = false
    if !versos.blank?

      self.lyric.each_line do |line|

        is_verse = nil

        versos.each do |value|

          if line =~ /\[#{value[1..-2]}\]/
            is_verse = value[1..-2]
          end

        end


        if is_verse
          if hash[hash_actual]
            hash[hash_actual].gsub!(/<br>$/, '')
          end

          hash_actual = is_verse.upcase
          hash[hash_actual] = ''
        else
          if line =~ /\b[CDEFGAB]m?7?\b/ and !is_chord
            is_chord = true
            hash[hash_actual] += line if chords
          else
            if chords
              hash[hash_actual] += line
            else
              hash[hash_actual] += line.gsub(/\n/, '<br>')
            end
            is_chord = false
          end
        end

      end
    end
    return hash
  end

  def songbooks_ago
    if self.songbooks.empty?
      return '∞'
    else
      sb = self.songbooks.order('fecha asc').last
      return Songbook.where('fecha > ?', sb.fecha).count
    end
  end


  def cantada_count
    if self.songbooks.empty?
      return 0
    else
      sb = self.songbooks.where('fecha > ?', Date.today-2.months)
      return sb.count
    end

  end

  def voted?(user)
    if !Vote.where('user_id = ? and song_id = ?', user.id, self.id).empty?
      return true
    else
      return false
    end
  end

end
