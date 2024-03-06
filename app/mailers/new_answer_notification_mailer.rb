class NewAnswerNotificationMailer < ApplicationMailer
  def  new_answer_notification(user,answer)
    @answer = answer
    if user.author?(answer.question)
      mail(to: user.email, subject: "You receive this email as a question's author")
    else
      mail(to: user.email, subject: "You receive this email as a question's subscriber") 
    end
  end

  private

  def subscribers
    Subscription.find_subscribers(@answer.question)
  end
end
