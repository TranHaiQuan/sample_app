class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.user.name.maximum}
  # start by string
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.user.email.maximum},
   format: {with: VALID_EMAIL_REGEX},
   uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.user.password.minimum}

  class << self

    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BBCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # return random token
    def new_token
      SecureRandom.urlsafe_base64
    end

  end

  # get and generate >> save in remember_digest
  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  # true if token matches th digest
  def authenticated? remember_token
    if remember_digest.nil?
      false
    else
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
end
  end

  # forget a user
  def forget
    update_attribute :remember_digest, nil
  end
end
