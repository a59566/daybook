class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    consumptions_path
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  def get_formatted_error_message(model)
    result = {}
    model_name = model.class.name.downcase
    model.errors.messages.each do |key, value|
      result["#{model_name}_#{key}"] = value
    end

    result
  end
end
