ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock_quantity, :image_url, :category_id, :image

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :stock_quantity
    column :category
    actions
  end

  filter :name
  filter :price
  filter :category

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
      f.input :stock_quantity
      f.input :image_url
      f.input :category
    end
    f.actions
  end



  remove_filter :image_attachment, :image_blob

  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.input :image, as: :file
    end
    f.actions
  end
end
