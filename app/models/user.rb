class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
  validates :name, presence: true, length: {maximum: Settings.user.name.maximum}
  # start by string
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: Settings.user.email.maximum},
   format: {with: VALID_EMAIL_REGEX},
   uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.user.password.minimum}, allow_nil: true

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
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
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

  # update attribute
  def activate
    update_attribute :activated, true
    update_attribute :activated_at, Time.zone.now
  end

  # Send activation email
  def sen_activation_email
      UserMailer.account_activation(self).deliver_now
  end
  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
