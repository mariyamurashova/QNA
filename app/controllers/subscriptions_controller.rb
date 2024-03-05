class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_subscription, only: :destroy
   before_action :find_question, only: :create_subscription
  #authorize_resource

  def create_subscription
    authorize! :create_subscription, @question
    @subscription = current_user.subscriptions.new(question_id: subscription_params[:question_id])
    if @subscription.save
      flash[:notice] = "the subscription has been successfully created"
      #render json: {render partial: 'subscriptions/delete_btn', status: :created }
    #else
      #render json: @subscription.errors.full_messages, status: :forbidden
    end
  end

  def destroy
    authorize! :destroy, @subscription
    #respond_to do |format|
      if @subscription
        @subscription.destroy
        @subscription.question
        flash[:notice] = "Your subscription has been successfully deleted"
        #format.json { render json: flash, status: :no_content }
        #format.js { render :destroy }
        #end
      else
        flash[:notice] = "You aren't subscribed"
       # format.json { render json: flash, status: :unprocessable_entity }
        #render flash#, status: :unprocessable_entity
        #end
      end
    #end
  end

  private
  def find_question
    @question = Question.find_by(id: subscription_params[:question_id])
  end

  def subscription_params
    params.permit(:question_id)
  end

  def find_subscription
    @subscription = Subscription.find_by(question_id: params[:id], user_id: current_user.id)
  end
end
