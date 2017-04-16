class Setting < ActiveRecord::Base
  attr_accessible :church_id, :songs_background, :songs_case, :songs_font_color, :songs_text_bg_color, :presentation_template, :anniversaries_background
  mount_uploader :songs_background, BackgroundUploader
  mount_uploader :anniversaries_background, BackgroundUploader

end
