ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, :first_name, :role

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :password, label: "Password" # Virtual attribute for Devise
      f.input :password_confirmation, label: "Password Confirmation" # Virtual attribute for Devise
      f.input :first_name, label: "First Name"
      f.input :role, as: :select, collection: User.roles.keys if User.respond_to?(:roles)
    end
    f.actions
  end
end
