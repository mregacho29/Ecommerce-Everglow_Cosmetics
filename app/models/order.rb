class Order < ApplicationRecord
  # Associations
  belongs_to :tax, optional: true # Links to the Tax model (optional association)
  belongs_to :user # Links to the User model
  has_one :payment # Links to the Payment model (one-to-one relationship)
  has_many :order_items, dependent: :destroy # Links to OrderItem model (one-to-many relationship)
  has_many :products, through: :order_items # Links to Product model through OrderItem

  # Validations
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 } # Ensures total_amount is present and non-negative

  # Enum for order status
  enum :status, { pending: 0, completed: 1, canceled: 2 } # Defines possible statuses for an order

  # Calculate the total amount for the order based on order items
  def calculate_total_amount
    order_items.sum { |item| item.quantity * item.price } # Sums up the total price of all order items
  end

# Calculate the grand total (total amount + tax amount)
def grand_total
  total_amount.to_f + tax_amount.to_f
end

  # Calculate the total tax amount for the order
  def calculate_tax
    return 0 unless tax # Return 0 if no tax is associated
    tax_rate = tax.gst + tax.pst + tax.hst # Sum up the tax rates (GST, PST, HST)
    total_amount * tax_rate # Calculate the tax amount based on the total amount
  end

  # Define ransackable associations for search functionality
  def self.ransackable_associations(auth_object = nil)
    [ "user" ] # Allows searching by user association
  end

  # Define ransackable attributes for search functionality
  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "status", "tax", "total_amount", "updated_at", "user_id" ] # Allows searching by these attributes
  end
end
