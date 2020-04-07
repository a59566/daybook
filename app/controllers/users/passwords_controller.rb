class Users::PasswordsController < ApplicationController
  skip_before_action :sign_in_required

  def new

  end

  def create
    @user = User.find_by(email: user_params[:email])

    if @user
      #UserMailer.reset_password_email(@user).deliver_now
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: { user_email: t('.no_user_error') }, status: :unprocessable_entity }
      end
    end
  end

  def edit

  end

  def update

  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end