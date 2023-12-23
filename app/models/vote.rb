class Vote < ApplicationRecord
  belongs_to :vottable, polymorphic: true
  belongs_to :user

  def self.exist?(user, vottable)
    if  self.where(user_id: user, vottable: vottable).length != 0
      vottable.errors.add(:'', "You couldn't vote twice!")
    end
  end

end
