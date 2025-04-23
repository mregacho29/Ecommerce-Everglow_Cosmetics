class ChangeStatusToIntegerInOrders < ActiveRecord::Migration[8.0]
  def up
    # Add a temporary column to store the integer status
    add_column :orders, :status_temp, :integer, default: 0

    # Map existing string values to integers
    Order.reset_column_information
    Order.find_each do |order|
      case order.status
      when 'new'
        order.update_column(:status_temp, 0)
      when 'paid', 'completed' # Map 'completed' to 'paid'
        order.update_column(:status_temp, 1)
      when 'shipped'
        order.update_column(:status_temp, 2)
      end
    end

    # Remove the old string column and rename the temporary column
    remove_column :orders, :status
    rename_column :orders, :status_temp, :status
  end

  def down
    # Add the old string column back
    add_column :orders, :status_temp, :string

    # Map integers back to strings
    Order.reset_column_information
    Order.find_each do |order|
      case order.status
      when 0
        order.update_column(:status_temp, 'new')
      when 1
        order.update_column(:status_temp, 'paid')
      when 2
        order.update_column(:status_temp, 'shipped')
      end
    end

    # Remove the integer column and rename the temporary column
    remove_column :orders, :status
    rename_column :orders, :status_temp, :status
  end
end
