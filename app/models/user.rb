class User < ApplicationRecord
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "email", "first_name", "id", "password_digest", "role", "updated_at" ]
  end
end
