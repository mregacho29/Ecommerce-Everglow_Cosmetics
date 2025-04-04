class Product < ApplicationRecord
  belongs_to :category

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end

  def self.ransackable_attributes(auth_object = nil)
    ["category_id", "created_at", "description", "id", "image_url", "name", "price", "stock_quantity", "updated_at"]
  end


end
