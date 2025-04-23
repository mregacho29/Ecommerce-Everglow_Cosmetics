class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items


  def self.ransackable_associations(auth_object = nil)
    auth_object ||= :default # Provide a default value if none is given
    [ "user", "order_items", "products" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    auth_object ||= :default # Provide a default value if none is given
    [ "created_at", "id", "status", "tax", "total_amount", "updated_at", "user_id" ]
  end
end
