class Api::V1::QuestionsController < Api::V1::BaseController 
  before_action :find_question, only: [:show, :update, :destroy]
  authorize_resource
  def index
    @questions = Question.all
    render json: @questions, fields: [:id, :title, :body, :created_at, :updated_at, :short_title]
  end

  def show
    render json: @question, fields: [:id, :title, :body, :created_at, :updated_at, :comments, :files, :links]
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_resource_owner
    if @question.save
      render json: @question,  status: :created 
    else
      render json: @question.errors, status: :no_content
    end
  end

  def update
    authorize! :update, @question
    if @question.update(question_params)
     render json: @question
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy!
    render json: @question
  end

  private

  def find_question
    @question =  Question.find(params.require(:id))
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end

end
