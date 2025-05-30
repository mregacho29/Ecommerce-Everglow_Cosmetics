class User < ApplicationRecord
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address
  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product

  # Add this association
  has_many :orders, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.ransackable_attributes(auth_object = nil)
    # List only the attributes you want to make searchable
    [ "created_at", "email", "first_name", "id", "role", "updated_at" ]
  end
end
