# frozen_string_literal: true

class Question < ApplicationRecord
  include Vottable
  include Commentable
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :aword, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: :author_id
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :aword, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation

  scope :created_24_hours, -> { where(created_at: 24.hours.ago..Time.now )}

  def subscribed?(user)
    self.subscriptions.where(user_id: user.id).length != 0
  end

  def subscribers
    subscribers = [ ]
    self.subscriptions.pluck(:user_id).each do |user_id|
      subscribers << User.find(user_id)
    end
    return subscribers
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

end
