module Vottable
  extend ActiveSupport::Concern
  included do
    has_many :votes, as: :vottable, dependent: :delete_all
  end

  def rating
    votes.sum(:value)
  end
  
end
