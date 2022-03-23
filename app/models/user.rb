class User < ApplicationRecord
  has_many :bank_account, class_name: '::BankAccount', inverse_of: :user

  validates :email, :password, :name, :surname, presence: true
  validates :email, uniqueness: true
  validates :password, length: { is: 8 }
  validates :password, format: { with: /(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[$*&@#])(?:([0-9a-zA-Z$*&@#])(?!\1)){8,}/,
                                 message: 'password must has a least 1 capital letter, 1 number and 1 special character.' }
  has_secure_password
end
