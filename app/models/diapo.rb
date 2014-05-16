class Diapo < ActiveRecord::Base
  attr_accessible :background, :info, :title, :show_title
  mount_uploader :background, BackgroundUploader

end
