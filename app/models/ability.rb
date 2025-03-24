# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the user here. For example:
    user ||= User.new
    
    can :read, Trail, public: true

    return unless user.present?  # additional permissions for logged in users (they can read their own posts)
    can :manage, Trail, user: user

    return unless user.admin?  # additional permissions for administrators
    can :manage, :all

    if user.admin?
      can :manage, :all  # Администратор может управлять всем
    else
      can :read, :all  # Все могут читать

      can :create, Trail  # Авторизованные пользователи могут создавать Trail
      can :update, Trail, user_id: user.id  # Пользователь может обновлять только свои Trail
      can :destroy, Trail, user_id: user.id  # Пользователь может удалять только свои Trail

      # Дополнительно:  Пользователь может управлять своим профилем
      can :update, Profile, user_id: user.id
      can :destroy, Profile, user_id: user.id
    end
    
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
