class Project < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	validates :comment, presence: true, length: { maximum: 140 }
	validates :user_id, presence: true

  def self.get_projects(user)
    project_ids = "SELECT project_id FROM relationships
                         WHERE user_id = :user_id"
    where("id IN (#{project_ids})", user_id: user.id)
  end
end
