ActiveAdmin.register Announcement do
  permit_params :title, :image

  form do |f|
    f.inputs "Announcement Details" do
      f.input :title
      f.input :image, as: :file # File upload field
    end
    f.actions
  end

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
