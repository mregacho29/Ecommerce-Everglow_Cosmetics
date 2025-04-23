class User < ApplicationRecord
  # Include default Devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    # List only the attributes you want to make searchable
    [ "created_at", "email", "first_name", "id", "role", "updated_at" ]
  end
end
