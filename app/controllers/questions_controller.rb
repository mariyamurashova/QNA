class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
    gon.question_id = @question.id
    gon.current_user = current_user.id if !current_user.nil?
    gon.author = @question.answers.last.author.id if !@question.answers.empty?
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
    if @question.author == current_user
      @question.destroy!
      flash[:notice] = 'Your question was successfully deleted'
      redirect_to questions_path
    else
      flash[:notice] = "You could'n delete this question"
      redirect_to @question
    end  
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
