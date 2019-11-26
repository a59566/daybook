class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable,
         :session_limitable

  has_many :consumptions, dependent: :delete_all
  has_many :tags, dependent: :delete_all
end
