class Comment < ApplicationRecord

  include PgSearch::Model
  multisearchable against: [:body, :commentable_type],
                  update_if: :body_previously_changed?
  pg_search_scope :search_by_comments, against: [:body]                

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :body, presence: true
end
