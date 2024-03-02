class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_subscription, only: :destroy

  authorize_resource

  def create
    authorize! :create, Subscription
    @subscription = current_user.subscriptions.new(question_id: subscription_params[:question_id])
    if @subscription.save
      flash.alert = "the subscription has been successfully created"
      render json: flash, status: :created
    else
      render json: @subscription.errors.full_messages, status: :forbidden
    end
  end

  def destroy
    if @subscription.destroy!
      flash[:notice] = 'Your question was successfully deleted'
      render json: flash, status: 204
    end
  end

  private

  def subscription_params
    params.permit(:question_id)
  end

  def find_subscription
    @subscription = Subscription.find(params[:id])
  end
end
