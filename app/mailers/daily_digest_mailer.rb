class DailyDigestMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.created_24_hours

    mail(to: user.email, subject: "you are subscribed to the daily newsletter from Q&A") if !user.nil?
  end

  def mail_for_author(user, answer)
    @answer = answer
    mail(to: user.email, subject: "You receive this email as a question's author") 
  end

   def  mail_for_subscribers(users, answer)
    @answer = answer
    users.each do |user|
      mail(to: user.email, subject: "You receive this email as a question's subscriber") 
    end
  end
end
