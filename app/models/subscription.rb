class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question

 validates_uniqueness_of :user_id, scope: :question_id, message: "you have already subscribed to the question updates"

  def self.find_subscribers(question)
    subscribers = [ ]
    self.where(question_id: question.id).pluck(:user_id).each do |user_id|
      subscribers << User.find(user_id)
    end
    return subscribers
  end
end
