class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    
    # Everyone can read songs (including guests)
    can :read, Song
    
    if user.persisted? # logged in user
      if user.has_role? :admin
        can :manage, :all
      elsif user.is_song_manager? || user.role >= 3
        # Song managers can create songs and manage their group's songs
        can :create, Song
        can [:update, :destroy], Song do |song|
          # Can manage songs from their primary group or any group they belong to
          song.group.present? && (
            user.group == song.group || 
            user.groups.include?(song.group)
          )
        end
        can :manage, Songbook
        can :manage, Presentation
        can :manage, Diapo
        can :manage, Anniversary
        can :manage, Setting
      elsif user.is_songbook_manager? || user.role >= 5
        # Songbook managers can manage songbooks
        can :manage, Songbook
        can :read, Song
        can :manage, Presentation
        can :manage, Diapo
        can :manage, Anniversary
        can :manage, Setting
      else
        # Regular users can create songs and edit songs from their groups
        can :create, Song
        can [:update, :destroy], Song do |song|
          # Can manage songs from their primary group or any group they belong to
          song.group.present? && (
            user.group == song.group || 
            user.groups.include?(song.group)
          )
        end
        can :read, Songbook
        can :read, Presentation
        can :read, Diapo
        can :read, Anniversary
        can :read, Setting
      end
      
      # All logged users can manage groups and collaborators
      can :manage, Group
      can :manage, GroupCollaborator
      can :manage, UserGroup
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
