class Order < ApplicationRecord
  belongs_to :user
  has_one :payment
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  enum :status, { pending: 0, completed: 1, canceled: 2 }

  # Rename the method to avoid conflict
  def calculate_total_amount
    order_items.sum { |item| item.quantity * item.price }
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "status", "tax", "total_amount", "updated_at", "user_id" ]
  end
end
