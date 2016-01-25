class User < ActiveRecord::Base
	before_save { self.email = email.downcase }
	validates :name, presence: true, length: { maximum: 100 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: true, length: { maximum: 250 }, 
						format: { with: VALID_EMAIL_REGEX }

	validates :user_type, presence: true
	enum user_type: [:user, :admin, :banned]

	has_secure_password
	validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
	validates :password_confirmation, presence: true, length: { minimum: 5}, allow_nil: true

	mount_uploader :picture, PictureUploader
	validate  :picture_size

	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
	private 

	def picture_size 
		if picture.size > 5.megabytes
			errors.add(:picture, "should be less then 5MB")
		end
  end

end

