class Vote < ApplicationRecord
  belongs_to :vottable, polymorphic: true
  belongs_to :user
end
