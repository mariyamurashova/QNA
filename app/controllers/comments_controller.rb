class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable

  def create
    @comment = @commentable.comments.new(user: current_user, body: comment_params[:body])

    respond_to do |format|
      if @comment.save
        format.json { render json: @comment.body } 
      else
        format.json do
          render json: @comment.errors.full_messages, status: :forbidden
        end
      end 
    end
  end

  def destroy

    @comment =Comment.find_by(commentable_id: params[:commentable_id], commentable_type: params[:commentable].capitalize, user_id: current_user)

     respond_to do |format|
      if @comment.destroy
        format.json do
          flash[:notice] = "Your comment was successfully deleted"
          render json: flash, status: :unprocessable_entity 
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end


  def set_commentable
    @commentable = commentable_name.classify.constantize.find(params["#{commentable_name.singularize}_id".to_sym])
  end

  def commentable_name
    params[:commentable]
  end

end
