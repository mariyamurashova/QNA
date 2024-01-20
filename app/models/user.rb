class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  has_many :answers, foreign_key: 'author_id'
  has_many :questions, foreign_key: "author_id"
  has_many :awords
  has_many :votes
  has_many :authorizations, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider:auth.provider, uid:auth.uid)
  end

end
