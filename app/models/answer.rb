# frozen_string_literal: true

class Answer < ApplicationRecord
  include Vottable
  include Commentable
  belongs_to :question
  belongs_to :author, class_name: "User", foreign_key: :author_id
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }



  def mark_as_best
    transaction do
      self.class.where(question_id: self.question_id).update_all(best: false)
      self.update(best: true)
    end
  end
end
