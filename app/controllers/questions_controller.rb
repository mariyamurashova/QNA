class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  after_action :publish_question, only: [:create]
  
  load_and_authorize_resource
  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    gon.question_id = @question.id
    gon.current_user = current_user.id if !current_user.nil?
  end

  def new
    @question = Question.new
    @question.build_aword
    @question.links.new
  end

  def edit
  end

  def create
    
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    attach_files
    @question.update(update_question_params)
  end

  def destroy
    @question.destroy!
    flash[:notice] = 'Your question was successfully deleted'
    redirect_to questions_path
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def attach_files
    if params[:question][:files].present?
      params[:question][:files].each do |file|
        @question.files.attach(file)
      end
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                    files:[], links_attributes: [ :name, :url ], aword_attributes: [ :title, :image ])
  end

  def update_question_params
    params.require(:question).permit(:title, :body, links_attributes: [ :name, :url, :_destroy ])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast("questions", ApplicationController.render(
        partial: 'questions/question_ac',
        locals: { question: @question}
      )
    )
  end
end
