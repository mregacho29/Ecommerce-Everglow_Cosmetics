class AddNotNullConstraintToTaxId < ActiveRecord::Migration[8.0]
  def change
    change_column_null :orders, :tax_id, false
  end
end
