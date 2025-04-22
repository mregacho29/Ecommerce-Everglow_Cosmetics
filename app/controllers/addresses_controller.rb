class AddressesController < ApplicationController
  before_action :authenticate_user!

  def new
    @address = current_user.build_address
  end

  def create
    @address = current_user.build_address(address_params)
    if @address.save
      redirect_to root_path, notice: "Shipping information saved successfully."
    else
      render :new, alert: "Failed to save shipping information."
    end
  end

  def edit
    @address = current_user.address
  end

  def update
    @address = current_user.address
    if @address.update(address_params)
      redirect_to root_path, notice: "Shipping information updated successfully."
    else
      render :edit, alert: "Failed to update shipping information."
    end
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :province, :postal_code, :country)
  end
end
