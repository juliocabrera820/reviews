class User < ApplicationRecord
  validates :username, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }
end
