class Public::SessionsController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  def new
  end

  def create
    if params[:email_address].blank? || params[:password].blank?
      flash.now[:alert] = "メールアドレスとパスワードを入力してください"
      render :new, status: :unprocessable_entity
      return
    end

    if user = User.authenticate_by(
      email_address: params[:email_address],
      password: params[:password]
    )
      start_new_session_for(user)
      redirect_to root_path
    else
      flash.now[:alert] = "メールアドレスまたはパスワードが違います"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    terminate_session
    redirect_to root_path
  end
end
