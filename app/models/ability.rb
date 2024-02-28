# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)

    @user = user
    if user 
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :read, Aword
    can :create, [Question, Answer, Comment]
    
    can :set_best, Answer do |answer|
      user.author?(answer.question)
    end
    can [:update, :destroy], [ Question, Answer ], author: user

    can :vote, [ Answer, Question ] do |vottable|
     !user.author?(vottable)
    end

    can :destroy, Vote, { user_id: user.id }

    can :destroy, Link, { linkable: { author_id: user.id } }

    can :me, User, { id: user.id } 
  end
end
