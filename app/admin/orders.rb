ActiveAdmin.register Order do
  index do
    selectable_column
    id_column
    column "Customer" do |order|
      "#{order.user.first_name} (#{order.user.email})"
    end
    column "Products Ordered" do |order|
      ul do
        order.order_items.each do |item|
          li "#{item.product.name} - Qty: #{item.quantity} - $#{item.price}"
        end
      end
    end
    column "Tax" do |order|
      number_to_currency(order.tax.to_f)
    end
    column "Total Amount" do |order|
      number_to_currency(order.total_amount.to_f)
    end
    column "Grand Total" do |order|
      number_to_currency((order.total_amount.to_f + order.tax.to_f).round(2))
    end
    column "Status" do |order|
      order.status.capitalize
    end
    column "Order Date", :created_at
    column "Last Updated", :updated_at
    actions
  end
end
