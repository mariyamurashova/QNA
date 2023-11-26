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
    if answer_params.include?(:best) 
       @answer.mark_as_best if question_author?
    else
      @answer.update(update_answer_params)
    end

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

  def need_to_attach_files?
     params[:answer][:files].present?
  end

  def attach_files
    if need_to_attach_files?
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
    params.require(:answer).permit(:body, :best)
  end

  def question_author?
    @answer.question.author == current_user
  end

end
