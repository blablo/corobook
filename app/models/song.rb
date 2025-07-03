# -*- coding: utf-8 -*-
class Song < ActiveRecord::Base
  attr_accessible :author, :link, :lyric, :mood, :order, :reference, :title, :user_id, :group_id
  belongs_to :user
  belongs_to :group
  has_many :songbook_songs
  has_many :songbooks, :through => :songbook_songs
  has_many :votes

  validates :title, presence: true
  validates :lyric, presence: true
  validates :order, presence: true
  validates :user, presence: true
  validates :group, presence: true
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
  # \b[CDEFGAB](?:#{1,2}|b{1,2})?(?:7?|m7?|sus2?)\b

  def hashed_lyric(show_chords = false)
    hash = { }
    actual_verse = ""

    self.lyric.each_line do |line|

      if line =~ /\[.*]/
        actual_verse = line.scan(/\[(.*)\]/i)[0][0]
        hash[actual_verse] = []
      else
        #        if line =~ /\b[CDEFGAB]m?7?\b/
        unless line.gsub(/\r\n/, '').blank?

           if line =~ /\b[CDEFGAB]m?7?\b/
#          if (line.scan(/\b[CDEFGAB.\/-](?:#\{1,2\}|b{1,2})?(?:7?|m7?|sus2?)\b/).join.size == line.gsub(/\s/, '').size)

        #  if (line.scan(/\b[CDEFGAB.\/-](?:.{1,2}|b{1,2})?(m7?|sus2?)?\b/).join.size == line.gsub(/\s/, '').size)
            hash[actual_verse] << { line: line.gsub(/\r\n/, ''), type: :chords} if show_chords
          else
            hash[actual_verse] << { line: line.gsub(/\r\n/, ''), type: :text}
          end
        end
      end

    end

    return hash
  end

  def sorted_array_lyric(show_chords = false)

    hl = self.hashed_lyric(show_chords)
    array = []
    order = order_list
    count = 0
    order.each_with_index do |verse, index|
      verse.strip!
      part = Marshal.load( Marshal.dump( hl[verse] ) )

      if order[index] == order[index-1] and index > 0
        count += 1
        slash = "/" * count

        #tmp_verse = Marshal.load( Marshal.dump( part ) )
        part.select{|key| key[:type] == :text}.first[:line].prepend(slash)
        part.select{|key| key[:type] == :text}.last[:line] += slash

        array.pop
        array << { label: verse, text: part}
        #hl[verse] = tmp_verse
      else
        count = 1
        array << { label: verse, text: part}
      end
    end

    return array
  end

  def order_list
    self.order.gsub(', ', ',').split(',')
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

  # Helper method to check if a user can edit this song
  def editable_by?(user)
    return false unless user && user.persisted?
    return true if user.has_role?(:admin)
    
    # Check if user belongs to the same group as the song
    return false unless self.group.present?
    
    user.group == self.group || user.groups.include?(self.group)
  end

end
