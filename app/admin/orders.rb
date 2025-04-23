ActiveAdmin.register Order do
  actions :all, except: [ :destroy ]

  # Permit parameters for mass assignment
  permit_params :status

  # Custom action to mark an order as shipped
  member_action :mark_as_shipped, method: :put do
    resource.update(status: :shipped)
    redirect_to resource_path, notice: "Order ##{resource.id} has been marked as shipped."
  end

  # Add a button to mark an order as shipped on the show page
  action_item :mark_as_shipped, only: :show, if: proc { resource.paid? } do
    link_to "Mark as Shipped", mark_as_shipped_admin_order_path(resource), method: :put
  end

  # Index page configuration
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
    column :status
    column :created_at
    column :updated_at
    actions
  end

  # Form configuration for editing orders
  form do |f|
    f.inputs do
      f.input :status, as: :select, collection: Order.statuses.keys
    end
    f.actions
  end
end
