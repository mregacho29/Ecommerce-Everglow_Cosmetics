class CreatePayments < ActiveRecord::Migration[8.0]
  def change
    create_table :payments do |t|
      t.references :order, null: false, foreign_key: true
      t.string :payment_method
      t.string :payment_status
      t.decimal :amount_paid

      t.timestamps
    end
  end
end
