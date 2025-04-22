class Product < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :tags

  has_one_attached :image # ActiveStorage attachment
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :stock_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.ransackable_associations(auth_object = nil)
    [ "category" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "category_id", "created_at", "description", "id", "image_url", "name", "price", "stock_quantity", "updated_at" ]
  end


  def display_image
    # Use the uploaded image if present, otherwise fallback to the image_url
    image.attached? ? image : image_url
  end
end
