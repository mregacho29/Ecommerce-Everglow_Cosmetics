class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum :status, { pending: 0, paid: 1, shipped: 2 }

  def self.ransackable_associations(auth_object = nil)
    auth_object ||= :default
    [ "user", "order_items", "products" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    auth_object ||= :default
    [ "created_at", "id", "status", "tax", "total_amount", "updated_at", "user_id" ]
  end


  def mark_as_paid
    update!(status: :paid)
  end

  def mark_as_shipped
    update!(status: :shipped)
  end
end
