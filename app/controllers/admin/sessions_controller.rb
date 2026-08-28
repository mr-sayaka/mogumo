class Admin::SessionsController < ApplicationController
  skip_before_action :require_authentication
  
  def new
  end

  def create
    admin = Admin.authenticate_by(
      email_address: params[:email_address],
      password: params[:password]
    )

    if admin
      start_new_session_for(admin)
      redirect_to admin_root_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが正しくありません"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to new_admin_session_path
  end
end