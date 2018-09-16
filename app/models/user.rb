#  == Schema Information
#
#  Table names : users
#
#  id                     :integer     not null, primary key
#  email                  :string      default (""), nut null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime    not null
#  updated_at             :datetime    not null
#  role                   :string
#  name                   :string      default:(""), null:false, limit: 32
#  avatar                 :string
#  job_title              :string      default:(""), limit: 32
#  website                :string      default:("")
#  authentication_token   :string
#  share_class_account    :integer     default:(0)

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates_presence_of :name

  has_many :projects


  def admin?
    self.role == "admin"
  end

end
