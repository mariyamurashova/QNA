class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :answers, foreign_key: 'author_id'
  has_many :questions, foreign_key: "author_id"
  has_many :awords
  has_many :votes

   def author_of?(vottable)
     if vottable.author == self
      vottable.errors.add(:'', "You couldn't vote for your #{vottable.class.to_s.downcase}")
    end
  end
end
