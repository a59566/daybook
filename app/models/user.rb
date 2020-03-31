class User < ApplicationRecord
  has_many :consumptions, dependent: :delete_all
  has_many :tags, dependent: :delete_all

  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
end
