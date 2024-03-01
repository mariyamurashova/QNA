class SendNotificationService
  def new_answer_notification(author, answer)
     DailyDigestMailer.new_answer(author, answer).deliver_later
  end
end
