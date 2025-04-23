class RenameTaxToTaxAmountInOrders < ActiveRecord::Migration[8.0]
  def change
    rename_column :orders, :tax, :tax_amount
  end
end
