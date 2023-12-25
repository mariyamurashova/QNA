class Vote < ApplicationRecord
  belongs_to :vottable, polymorphic: true
  belongs_to :user

  validates :user, uniqueness: { scope: [ :vottable], :message => "you couldn't vote twice" }
 
  def author_of_resource
    if self.user_id == self.vottable.author_id
      errors.add(:user,"You couldn't vote for your #{self.vottable.class.to_s.downcase}")
    end 
  end

end
