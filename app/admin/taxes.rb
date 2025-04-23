ActiveAdmin.register Tax do
  # Permit parameters for mass assignment
  permit_params :province, :gst, :pst, :hst



  # Index page configuration
  index do
    selectable_column
    id_column
    column :province
    column :gst
    column :pst
    column :hst
    actions
  end

  # Form configuration for editing/creating tax records
  form do |f|
    f.inputs do
      f.input :province
      f.input :gst
      f.input :pst
      f.input :hst
    end
    f.actions
  end

  # Show page configuration
  show do
    attributes_table do
      row :province
      row :gst
      row :pst
      row :hst
    end
  end
end
