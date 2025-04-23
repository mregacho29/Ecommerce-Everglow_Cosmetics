class Order < ApplicationRecord
  belongs_to :tax, optional: true
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

  # Calculate the total tax amount
  def calculate_tax
    return 0 unless tax # Return 0 if no tax is associated
    tax_rate = tax.gst + tax.pst + tax.hst
    total_amount * tax_rate
  end

  def self.ransackable_associations(auth_object = nil)
    [ "user" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "status", "tax", "total_amount", "updated_at", "user_id" ]
  end
end
