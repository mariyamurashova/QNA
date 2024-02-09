class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy, :update]
  before_action :find_answer_best, only: [:set_best]

  after_action :publish_answer, only: [:create]
  authorize_resource

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user
    @answer.save
  end

  def update
    attach_files
    @answer.update(update_answer_params)  
   
    @question = @answer.question
  end

  def destroy
    @answer.destroy
    flash[:notice] = 'Your answer was successfully deleted'
  end

  def set_best
    if can?(:set_best, @answer)
      @answer.mark_as_best 
      @answer.author.awords << @answer.question.aword if @answer.question.aword
      @question = @answer.question
    end
  end

private

  def find_answer_best
    @answer=Answer.with_attached_files.find(params[:answer][:answer_id])
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
    params.require(:answer).permit(:answer_id, :body, :best, 
                                    files:[], links_attributes: [ :name, :url ])
  end

  def update_answer_params
    params.require(:answer).permit(:body, :best, links_attributes: [:name, :url])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("answer_for_question#{@answer.question.id}",
                { answer_author: @answer.author.id,  
                  partial: ApplicationController.render(
                                                partial: 'answers/answer_ac',
                                                locals: { answer: @answer }
                  )}
                  )
  end 
end
