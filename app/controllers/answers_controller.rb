class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :update]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    attach_files
    @answer.update(update_answer_params)  if !set_best
  
    @question = @answer.question
  end

  def destroy
    if @answer.author == current_user
      @answer.destroy
      flash[:notice] = 'Your answer was successfully deleted'
    else
      flash[:notice] = "You could'n delete this answer"
    end
  end

  private

   def set_best
    if answer_params.include?(:best) && question_author?
      @answer.mark_as_best 
      @answer.author.awords << @answer.question.aword if @answer.question.aword
    end
   end

  def set_aword
    @answer.author.awords << @answer.question.aword if @answer.question.aword
  end

  def attach_files
    if params[:answer][:files].present?
      params[:answer][:files].each do |file|
        @answer.files.attach(file)
      end
    end
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, :best, 
                                    files:[], links_attributes: [ :name, :url ])
  end

  def update_answer_params
    params.require(:answer).permit(:body, :best, links_attributes: [:name, :url])
  end

  def question_author?
    @answer.question.author == current_user
  end
  
end
