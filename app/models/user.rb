class User < ActiveRecord::Base
	has_many :projects
	has_many :relationships, foreign_key: "user_id", dependent: :destroy
  #has_many :projects, through: :relationships, source: :project_id

	before_save { self.email = email.downcase }
	validates :name, presence:true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, 
						format: { with: VALID_EMAIL_REGEX }, 
						uniqueness:{ case_sensitive: false } 
  has_secure_password
	validates :password, length: { minimum: 6 }

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

	def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def get_projects
    #TODO group_by中的&是用来做什么的？
    Project.get_projects(self).group_by(&:name);
  end
end
