class Api::V1::QuestionsController < Api::V1::BaseController
  protect_from_forgery with: :null_session
  #skip_before_action :verify_authenticity_token
 authorize_resource
  def index
    @questions = Question.all
    render json: @questions, fields: [:id, :title, :body, :created_at, :updated_at, :short_title]
  end

  def show
    @question = Question.where(id: params[:id])
    render json: @question, fields: [:comments, :files, :links]
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_user
    if @question.save
      render json: @question,  status: :created 
    else
      render json: flash
    end 
  end

  private

  def question_params
    params.permit(:title, :body, links_attributes: [ :name, :url ], aword_attributes: [ :title, :image ])
  end

end
