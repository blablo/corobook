class Group < ActiveRecord::Base
  attr_accessible :name
  has_many :users

  def add_to_group(user, role = 1)
    usergroup = UserGroup.new(:user_id => user.id, :group_id => self.id)

    if self.user_groups.empty?
      usergroup.role = 9
    else
      usergroup.role = role
    end

    if !has_user?(user)
      usergroup.save
    end

  end

  def has_user?(user)
    !self.user_groups.where('user_id = ?', user.id).first.nil?
  end


end
