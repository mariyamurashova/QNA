class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = Answer.where(question_id: params[:question_id])
    render json: @answers, fields: [:id, :body, :created_at, :updated_at]
  end

  def show
    @answer = Answer.where(id: params[:id])
    render json: @answer, fields: [:id, :body, :created_at, :updated_at, :files, :links, :comments]
  end
end
