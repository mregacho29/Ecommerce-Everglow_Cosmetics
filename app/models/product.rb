class Product < ApplicationRecord
  belongs_to :category

  def self.ransackable_associations(auth_object = nil)
    ["category"]
  end

end
