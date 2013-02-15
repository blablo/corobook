class GroupCollaborator < ActiveRecord::Base
  attr_accessible :email, :group_id, :name, :role, :user_id
end
