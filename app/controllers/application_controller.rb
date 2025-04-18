class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale

  # Ensure locale is not unintentionally added to URLs
  def default_url_options
    { locale: I18n.locale }
  end

  private

  def set_locale
    I18n.locale = valid_locale(params[:locale]) || I18n.default_locale
  end

  def valid_locale(locale)
    I18n.available_locales.map(&:to_s).include?(locale) ? locale : nil
  end
end
