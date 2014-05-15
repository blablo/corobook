class Diapo < ActiveRecord::Base
  attr_accessible :background, :info, :title
  mount_uploader :background, BackgroundUploader

end
