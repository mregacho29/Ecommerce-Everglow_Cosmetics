class Ability
  include CanCan::Ability

  def initialize(user)
    # Example: Super Admins can manage everything
    if user.super_admin? # Replace with your logic for identifying super admins
      can :manage, :all
    else
      # Regular Admins can only read AdminUser records
      can :read, AdminUser
    end
  end
end