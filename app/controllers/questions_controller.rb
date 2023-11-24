class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
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

  def need_to_attach_files?
    params[:question][:files].present?
  end

  def attach_files
    if need_to_attach_files?
      params[:question][:files].each do |file|
        @question.files.attach(file)
      end
    end
  end

  def question_params
    params.require(:question).permit(:title, :body, 
                                    files:[], links_attributes: [:name, :url])
  end

  def update_question_params
    params.require(:question).permit(:title, :body)
  end
end
