# frozen_string_literal: true

class Question < ApplicationRecord
  include Vottable
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_one :aword, dependent: :destroy
  belongs_to :author, class_name: "User", foreign_key: :author_id

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :aword, reject_if: :all_blank

  validates :title, :body, presence: true
end
