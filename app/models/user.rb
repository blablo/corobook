class User < ActiveRecord::Base
  belongs_to :group
  belongs_to :church
  has_many :votes

  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :role_ids, :as => :admin
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :group_id
  
  def is_viewer?
    self.role == 1
  end

  def is_song_manager?
    self.role == 3
  end

  def is_songbook_manager?
    self.role == 5
  end

  def is_admin?
    self.role == 9
  end

  
end
