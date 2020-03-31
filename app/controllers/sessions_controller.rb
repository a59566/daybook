class SessionsController < ApplicationController
  skip_before_action :sign_in_required

  def new
  end

  def create
    @user = User.find_by(email: user_params[:email])

    if @user&.authenticate(user_params[:password])
      session[:user_id] = @user.id
      redirect_to consumptions_path, notice: t('.success_message')
    else
      respond_to do |format|
        format.html { render :new }

        if @user
          format.js { render json: { user_password: t('.password_error') }, status: :unprocessable_entity }
        else
          format.js { render json: { user_email: t('.no_user_error') }, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    reset_session
    redirect_to sign_in_path, notice: t('.success_message')
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
