class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question
  before_action :find_answer, only: [:destroy]

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author = current_user

    if @answer.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      redirect_to @question
    end
  end

  def destroy
    if @answer.author == current_user
      @answer.destroy
      flash[:notice] = 'Your question was successfully deleted'
    else
      flash[:notice] = "You could'n delete this question"
    end
    
    redirect_to @question
  end


  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
