class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscribers.each do |user|
      NewAnswerNotificationMailer.new_answer_notification(user,answer).deliver_later
    end
  end
end
