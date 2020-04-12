class Users::PasswordsController < ApplicationController
  skip_before_action :sign_in_required

  def new

  end

  def create
    @user = User.find_by(email: user_params[:email])

    if @user
      token = @user.reset_password_preparation
      UserMailer.reset_password(@user, token).deliver_now
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
    @user = User.find_by(email: user_params[:email])

    if @user && @user.authenticate_reset_password_token(user_params[:reset_password_token])
      @user.password = user_params[:password]
      @user.reset_password_token = nil
      @user.reset_password_sent_at = nil

      @user.save
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render get_formatted_error_message(@user), status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end
end