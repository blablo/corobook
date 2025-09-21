# -*- coding: utf-8 -*-
class Song < ActiveRecord::Base
  attr_accessible :author, :link, :lyric, :mood, :order, :reference, :title
  belongs_to :user
  belongs_to :group
  has_many :songbook_songs
  has_many :songbooks, :through => :songbook_songs
  has_many :votes

  validates :title, presence: true
  validates :lyric, presence: true
  validates :order, presence: true
  validates :group, presence: true
  validate :validate_sintax
  validate :validate_user_on_create
  
  before_validation :log_validation_state

  def validate_sintax
    if self.lyric.scan(/\[.*\]/i).blank?
      errors.add(:order, "No se encontraron versos en el texto. Ej: [CORO] ")
    end
  end

  def log_validation_state
    Rails.logger.info "=== SONG VALIDATION STATE ==="
    Rails.logger.info "Song ID: #{self.id}"
    Rails.logger.info "New record?: #{new_record?}"
    Rails.logger.info "User ID: #{user_id}"
    Rails.logger.info "Group ID: #{group_id}"
    Rails.logger.info "User present?: #{user.present?}"
    Rails.logger.info "Group present?: #{group.present?}"
    Rails.logger.info "================================"
  end

  def validate_user_on_create
    Rails.logger.info "Custom user validation - new_record?: #{new_record?}, user blank?: #{user.blank?}"
    if new_record? && user.blank?
      Rails.logger.error "Song validation failed - User required for new songs"
      errors.add(:user, "can't be blank")
    else
      Rails.logger.info "User validation passed - existing song or user present"
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
      chord_matches = line.scan(/\b[CDEFGAB](?:#|b)?(?:m|maj|dim|aug|sus[24]?)?(?:7|9|11|13)?\b/)
      line_without_spaces = line.gsub(/\s/, '')
      chord_content = chord_matches.join('')
      is_chord_line = (chord_matches.length >= 2) || 
                     (chord_content.length > 0 && line_without_spaces.length > 0 && 
                      (chord_content.length.to_f / line_without_spaces.length) >= 0.6)
      
      if is_chord_line and !prev_chords
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
        unless line.gsub(/\r\n/, '').blank?
          clean_line = line.gsub(/\r\n/, '')
          # Check if line is mostly chords by counting chord matches vs total content
          chord_matches = line.scan(/\b[CDEFGAB](?:#|b)?(?:m|maj|dim|aug|sus[24]?)?(?:7|9|11|13)?\b/)
          # Remove all whitespace and see if chords make up most of the content
          line_without_spaces = line.gsub(/\s/, '')
          chord_content = chord_matches.join('')
          
          # A line is considered chords if:
          # 1. It has at least 2 chord matches, OR
          # 2. Chord content makes up at least 60% of non-space characters
          is_chord_line = (chord_matches.length >= 2) || 
                         (chord_content.length > 0 && line_without_spaces.length > 0 && 
                          (chord_content.length.to_f / line_without_spaces.length) >= 0.6)
          
          if is_chord_line
            hash[actual_verse] << { line: clean_line, type: :chords} if show_chords
          else
            hash[actual_verse] << { line: clean_line, type: :text}
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
          chord_matches = line.scan(/\b[CDEFGAB](?:#|b)?(?:m|maj|dim|aug|sus[24]?)?(?:7|9|11|13)?\b/)
          line_without_spaces = line.gsub(/\s/, '')
          chord_content = chord_matches.join('')
          is_chord_line_diapo = (chord_matches.length >= 2) || 
                               (chord_content.length > 0 && line_without_spaces.length > 0 && 
                                (chord_content.length.to_f / line_without_spaces.length) >= 0.6)
          
          if is_chord_line_diapo and !is_chord
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
    
    # User can edit if they belong to the same group as the song
    # (song user_id can be nil for legacy songs)
    user.group == self.group || user.groups.include?(self.group)
  end

end
