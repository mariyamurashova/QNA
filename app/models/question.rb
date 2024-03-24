# frozen_string_literal: true

class Question < ApplicationRecord
  include Vottable
  include Commentable
  include PgSearch::Model
  multisearchable against: [:title, :body],
                 # update_if: :body_previously_changed?,
                #  update_if: :title_previously_changed?
  additional_attributes: -> (question) { { author_id: question.author_id } }
  pg_search_scope :search_by_questions, 
                  against: [:title, :body, :author_id],   
                   using: {
                    trigram: {
                      word_similarity: true
                    }
                  }

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
