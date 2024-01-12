class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable
 
   after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
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

  def id_for_broadcast
    if commentable_name.include?("answers")
       @comment.commentable.question.id
    else
      @comment.commentable.id
    end
  end

  def publish_comment
    return if @comment.errors.any?
     ActionCable.server.broadcast("commentable_#{id_for_broadcast}_comment", 
                {commentable_id: @comment.commentable_id, commentable_name: commentable_name,
                  partial: ApplicationController.render(                                                               
                          partial: 'comments/comment',
                          locals: { comment: @comment}  )}
                  )
  end
end

