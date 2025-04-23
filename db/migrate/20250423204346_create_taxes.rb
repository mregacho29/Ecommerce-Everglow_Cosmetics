class CreateTaxes < ActiveRecord::Migration[8.0]
  def change
    create_table :taxes do |t|
      t.string :province
      t.decimal :gst
      t.decimal :pst
      t.decimal :hst

      t.timestamps
    end
  end
end
