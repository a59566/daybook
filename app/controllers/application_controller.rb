class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :sign_in_required
  helper_method :current_user

  def get_formatted_error_message(model)
    result = {}
    model_name = model.class.name.downcase
    model.errors.messages.each do |key, value|
      result["#{model_name}_#{key}"] = value
    end

    result
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def sign_in_required
    redirect_to sign_in_path, alert: t('sign_in_required_message') unless current_user
  end
end
