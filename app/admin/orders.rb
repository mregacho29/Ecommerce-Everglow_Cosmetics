ActiveAdmin.register Order do
  index do
    selectable_column
    id_column
    column "Customer" do |order|
      "#{order.user.full_name} (#{order.user.email})"
    end
    column "Products Ordered" do |order|
      ul do
        order.order_items.each do |item|
          li "#{item.product.name} - Qty: #{item.quantity} - $#{item.price}"
        end
      end
    end
    column "Tax" do |order|
      number_to_currency(order.tax)
    end
    column "Total Amount" do |order|
      number_to_currency(order.total_amount)
    end
    column "Grand Total" do |order|
      number_to_currency(order.total_amount + order.tax)
    end
    column "Order Date", :created_at
    actions
  end
end
