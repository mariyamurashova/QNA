class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_subscription, only: :destroy
  
  def create
    authorize! :create, Subscription
    @subscription = current_user.subscriptions.new(question_id: subscription_params[:question_id])
    if @subscription.save
      flash[:notice] = "the subscription has been successfully created"
      render json: flash, status: :created
    else
      render json: @subscription.errors.full_messages, status: :forbidden
    end

    #flash[:notice] = "the subscription has been successfully created" if @subscription.save
  end

  def destroy
    authorize! :destroy, @subscription
    if @subscription
      @subscription.destroy
      @subscription.question
      flash[:notice] = "Your subscription has been successfully deleted"
    else
      flash[:notice] = "You aren't subscribed"
    end
  end

  private

  def subscription_params
    params.permit(:question_id)
  end

  def find_subscription
    @subscription = Subscription.find_by(question_id: params[:id], user_id: current_user.id)
  end
end
