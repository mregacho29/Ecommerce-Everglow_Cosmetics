ActiveAdmin.register Announcement do
  # Permit parameters for creating and updating announcements
  permit_params :title, :image

  # Form for creating/editing announcements

  remove_filter :image_attachment, :image_blob

  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.input :image, as: :file
    end
    f.actions
  end

  # Display uploaded image in the admin show page
  show do
    attributes_table do
      row :title
      row :image do |announcement|
        if announcement.image.attached?
          image_tag url_for(announcement.image), style: "max-width: 300px; max-height: 200px;"
        else
          "No Image Uploaded"
        end
      end
    end
  end
end
