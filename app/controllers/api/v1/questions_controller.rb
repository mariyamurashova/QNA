class Api::V1::QuestionsController < Api::V1::BaseController 
 authorize_resource
  def index
    @questions = Question.all
    render json: @questions, fields: [:id, :title, :body, :created_at, :updated_at, :short_title]
  end

  def show
    @question = Question.where(id: params[:id])
    render json: @question, fields: [:id, :title, :body, :created_at, :updated_at, :comments, :files, :links]
  end

  def create
    @question = Question.new(question_params)
    @question.author = current_resource_owner
    render json: @question,  status: :created if @question.save
  end

  def update
    @question =  Question.find(params.require(:id))
    authorize! :update, @question
    if @question.update(question_params)
     render json: @question
    end
  end


  def destroy
    @question =  Question.find(params.require(:id))
    authorize! :destroy, @question
    @question.destroy!
    flash[:notice] = 'Your question was successfully deleted'
    render json: flash
  end

  private

  def question_params
    params.permit(:title, :body)
  end

end
