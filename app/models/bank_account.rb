class BankAccount < ApplicationRecord
  belongs_to :user, class_name: '::User'

  validates :user_id, :amount, presence: true
end
