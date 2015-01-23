class Comment < ActiveRecord::Base
belongs_to :commentable, :polymorphic => true
belongs_to :user

validates :comment,:user_id, presence: true

end
