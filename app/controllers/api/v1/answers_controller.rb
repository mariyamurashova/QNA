class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_answer, only: [:show, :update, :destroy]
  authorize_resource

  def index
    @answers = Answer.where(question_id: params[:question_id])
    render json: @answers, fields: [:id, :body, :created_at, :updated_at]
  end

  def show
    render json: @answer, fields: [:id, :body, :created_at, :updated_at, :files, :links, :comments]
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_resource_owner
    if @answer.save
      render json: @answer if @answer.save
    else
      render json: @answer.errors, status:204, fields: :errors
    end
  end

  def update
    authorize! :update, @answer
    if @answer.update(answer_params)
     render json: @answer
    else
      render json: @answer.errors, status: 204
    end
  end


  def destroy
    @answer=  Answer.find(params.require(:id))
    authorize! :destroy, @answer
    @answer.destroy!
    render json: @answer
  end

  private

  def find_answer
    @answer = Answer.find(params.require(:id))
  end

   def answer_params
    params.permit(:body, :best)
  end
end
