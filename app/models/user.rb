class User < ActiveRecord::Base

	validates :name, presence: true, length: { maximum: 100 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: true, length: { maximum: 250 }, 
						format: { with: VALID_EMAIL_REGEX }

	validates :userType, presence: true
	enum userType: [:user, :admin, :banned]

	has_secure_password
	validates :password, presence: true, length: { minimum: 5 }
	validates :password_confirmation, presence: true, length: { minimum: 5}
end
