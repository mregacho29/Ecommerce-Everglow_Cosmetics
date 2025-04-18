ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :first_name, :role

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password, label: "Password" # Devise handles this
      f.input :password_confirmation, label: "Password Confirmation" # Devise handles this
      f.input :first_name, label: "First Name"
      f.input :role, as: :select, collection: ["admin", "user"] # Adjust roles as needed
    end
    f.actions
  end
end