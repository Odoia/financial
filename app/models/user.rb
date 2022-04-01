class User < ApplicationRecord
  has_many :bank_account, class_name: '::BankAccount', inverse_of: :user

  validates :email, :password, :name, :surname, presence: true, on: :create
  validates :email, uniqueness: true
  validates :password, length: { is: 8 }, on: :create
  validates :password, format: { with: /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[$*&@#])(?:([0-9a-zA-Z$*&@#])(?!\1)){8,}/,
                                 message: 'password must has a least 1 capital letter, 1 number and 1 special character.' }, on: :create
  has_secure_password

  def generate_password_token!
    self.reset_password_token = generate_token
    self.reset_password_sent_at = Time.now
    save!
  end

  def password_token_valid?
    (self.reset_password_sent_at + 2.hours) > Time.now
  end

  def reset_password!(password)
    self.reset_password_token = nil
    self.password = password
    save!
  end

  private

  def generate_token
    SecureRandom.hex(10)
  end
end
