# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :new_user, :answer_paramas

  def initialize(user, params=nil)
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
    can :create, [Question, Answer, Comment]
    can :set_best, Answer do |answer|
      answer.question.author == @user 
    end

    can [:destroy, :update], [Question], author: @user

    can [:update, :destroy], Answer, author: @user
    can [:destroy, :update], Comment, user: @user
  end
end
