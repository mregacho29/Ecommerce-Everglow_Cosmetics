class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_price
    order_items.sum { |item| item.quantity * item.product.price }
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "status", "tax", "total_amount", "updated_at", "user_id" ]
  end
end
