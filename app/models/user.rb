class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :answers, foreign_key: 'author_id'
  has_many :questions, foreign_key: "author_id"
  has_many :awords
  has_many :votes
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def self.find_for_oauth(auth)
    FindForOauthService.new(auth).call
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth[:provider], uid: auth[:uid])
  end

  def self.find_user(email)
    self.where(email: email).first
  end

  def self.create_user(email)
    password = Devise.friendly_token[0, 20] 
    self.create(email: email, password: password, password_confirmation: password)
  end

  def author?(resource)
    self.id == resource.author_id
  end

end
