class UsersController < ApplicationController
  skip_before_action :sign_in_required

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to consumptions_path, notice: t('.success_message')
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render json: get_formatted_error_message(@user), status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password , :password_confirmation)
  end
end
