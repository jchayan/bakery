class SheetsController < ApplicationController
  before_action :authenticate_user!

  def new
    @oven = find_user_oven
    if @oven.sheet.present?
      redirect_to @oven, alert: 'A sheet with cookies is already in the oven!'
    else
      @sheet = @oven.build_sheet
    end
  end

  def create
    quantity = params[:quantity].to_i
    @oven = current_user.ovens.find_by!(id: params[:oven_id])

    @sheet = @oven.create_sheet!
    cookies = quantity.times.map { @sheet.cookies.create!(cookie_params) }

    @oven.cook
    redirect_to oven_path(@oven)
  end

  private

  def sheet_params
    params.require(:sheet).permit(:quantity, cookie: [:fillings])
  end

  def cookie_params
    sheet_params.require(:cookie)
  end

  def find_user_oven
    current_user.ovens.find_by!(id: params[:oven_id])
  end
end
