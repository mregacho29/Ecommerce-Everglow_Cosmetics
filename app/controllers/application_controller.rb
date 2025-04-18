class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Ensure locale is not unintentionally added to URLs
  def default_url_options
    { locale: nil }
  end
end
