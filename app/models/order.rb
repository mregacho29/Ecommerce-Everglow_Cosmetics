class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items
  has_many :products, through: :order_items

  enum status: { new: 0, paid: 1, shipped: 2 }


  def self.ransackable_associations(auth_object = nil)
    [ "user", "order_items", "products" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "status", "tax", "total_amount", "updated_at", "user_id" ]
  end
end
