class UserMailer < ApplicationMailer
  def reset_password(user)
    @user = user
    mail(
      subject: t('.subject'),
      to: @user.email
    )
  end
end
