class User < ActiveRecord::Base
	attr_accessor :activation_token
	before_save { self.email = email.downcase }
	before_create :create_activation_digest
	validates :name, presence: true, length: { maximum: 100 }

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, uniqueness: true, length: { maximum: 250 }, 
						format: { with: VALID_EMAIL_REGEX }

	validates :user_type, presence: true
	enum user_type: [:user, :admin, :banned]

	has_secure_password
	validates :password, presence: true, length: { minimum: 5 }, allow_nil: true
	validates :password_confirmation, presence: true, length: { minimum: 5}, allow_nil: true

	validates :reachable, presence: true

	mount_uploader :picture, PictureUploader
	validate  :picture_size

	def User.new_token
    SecureRandom.urlsafe_base64
  end

	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def authenticated_activation?( token)
    return false if activation_digest.nil?
    BCrypt::Password.new(activation_digest).is_password?(token)
  end

  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
	private 

	def create_activation_digest
		 puts 'crateion'
     self.activation_token  = User.new_token
     puts self.activation_token
     self.activation_digest = User.digest( self.activation_token )
  end

	def picture_size 
		if picture.size > 5.megabytes
			errors.add(:picture, "should be less then 5MB")
		end
  end

end

