class AddTaxToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :tax, foreign_key: true, null: true
  end
end
