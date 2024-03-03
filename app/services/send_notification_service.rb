class SendNotificationService
  def notification_to_author(author, answer)
    DailyDigestMailer.mail_for_author(author, answer).deliver_later
  end

  def notification_to_subscribers(subscribers, answer)
    DailyDigestMailer.mail_for_subscribers(subscribers, answer).deliver_later
  end
end
