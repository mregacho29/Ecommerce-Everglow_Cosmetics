class ApplicationController < ActionController::Base
  before_action :set_locale

  def set_locale
    I18n.locale = valid_locale(params[:locale]) || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  private

  # Define the valid_locale method
  def valid_locale(locale)
    I18n.available_locales.map(&:to_s).include?(locale) ? locale : nil
  end
end
