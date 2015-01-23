class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :planning_sheets
  has_many :planned_tasks, through: :planning_sheets
  has_many :comments, through: :planning_sheets
  has_many :team_users   
  has_many :teams, through: :team_users
  has_many :user_skills   
  has_many :technologies, through: :user_skills
  has_many :projects  
  has_many :resource_requests
  has_many :comments
  belongs_to :role 
  
  validates :first_name,:last_name,:role_id, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :employee_id, presence: true, uniqueness: { case_sensitive: false }
  attr_accessor :confirm_password

  def full_name
    "#{first_name} #{last_name}"
  end

    #for checking user is active or not
  def active_for_authentication?
    super && account_active?
  end

  def account_active?
    status=="active"
  end

end
