class Public::UsersController < ApplicationController
  allow_unauthenticated_access only: [:new, :create]

  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :ensure_current_user, only: [:edit, :update, :destroy]

  def index
  @users = User.order(created_at: :desc)
  end

  def mypage
  @user = Current.user
  @posts = @user.posts.order(created_at: :desc)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      start_new_session_for @user
      redirect_to root_path, notice: "登録しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    # ログインユーザーの投稿一覧
    # Postモデルを実装したらここで取得します
    # @posts = @user.posts
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to public_user_path(@user), notice: "ユーザー情報を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy

  terminate_session
  @user.destroy

  redirect_to root_path, notice: "退会しました。"
end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_current_user
    unless Current.user == @user
      redirect_to public_mypage_path, alert: "他のユーザーの編集はできません。"
    end
  end

  def user_params
    params.require(:user).permit(
      :name,
      :email_address,
      :password,
      :password_confirmation,
      :introduction,
      :profile_image
    )
  end
end