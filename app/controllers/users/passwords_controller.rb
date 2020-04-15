class Users::PasswordsController < ApplicationController
  skip_before_action :sign_in_required

  def new; end

  def create
    @user = User.find_by(email: user_params[:email])

    if @user
      @user.reset_password_preparation
      UserMailer.reset_password(@user).deliver_now
    end

    flash.now[:notice] = t('.notice')
    render :new
  end

  def edit; end

  def update
    @user = User.find_by(email: user_params[:email])
    if @user&.reset_password_token_digest.nil? ||
       !@user&.authenticate_reset_password_token(user_params[:reset_password_token])
      @user.errors.add(:reset_password_token, :error)
      respond_to do |format|
        format.js { render json: get_formatted_error_message(@user), status: :unprocessable_entity }
      end
      return
    end

    if @user.update(password_params)
      @user.update_attribute(:reset_password_token, nil)
      @user.update_attribute(:reset_password_sent_at, nil)
      redirect_to sign_in_path, notice: t('.success')
    else
      respond_to do |format|
        format.js { render json: get_formatted_error_message(@user), status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :reset_password_token)
  end

  def password_params
    user_params.permit(:password, :password_confirmation)
  end
end