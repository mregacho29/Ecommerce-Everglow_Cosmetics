class RenameUnitPriceToPriceInOrderItems < ActiveRecord::Migration[8.0]
  def change
    rename_column :order_items, :unit_price, :price
  end
end
