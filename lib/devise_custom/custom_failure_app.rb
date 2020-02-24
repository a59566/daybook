class CustomFailureApp < Devise::FailureApp
  def redirect_url
    if request.xhr?
      { controller: 'devise/sessions', action: :new, status: :see_other }
    else
      super
    end
  end
end