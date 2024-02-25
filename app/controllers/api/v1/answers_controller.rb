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

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    @answer.author = current_resource_owner
    render json: @answer if @answer.save
  end

  def update
    @answer =  Answer.find(params.require(:id))
    authorize! :update, @answer
    if @answer.update(answer_params)
     render json: @answer
    end
  end


  def destroy
    @answer=  Answer.find(params.require(:id))
    authorize! :destroy, @answer
    @answer.destroy!
    flash[:notice] = 'Your answer was successfully deleted'
    render json: flash
  end

  private

   def answer_params
    params.permit(:body, :best)
  end
end
