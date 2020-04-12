class UserMailer < ApplicationMailer
  def reset_password(user, token)
    @user = user
    @token = token
    mail(
      subject: '',
      to: @user.email
    )
  end
end
