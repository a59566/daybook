class UserMailer < ApplicationMailer
  def reset_password_email(user)
    @user = user
    mail(
      subject: '',
      to: @user.email
    )
  end
end
