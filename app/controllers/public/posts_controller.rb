class Public::PostsController < ApplicationController
  before_action :require_authentication

  def new
    @post = Current.user.posts.build
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to public_post_path(@post), notice: "投稿しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
    @post = Post.includes(:user, comments: :user).find(params[:id])
  end

  def edit
    @post = Current.user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to public_posts_path, alert: "他のユーザーの投稿は編集できません。"
  end

  def update
    @post = Current.user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to public_post_path(@post), notice: "投稿を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to public_posts_path, alert: "他のユーザーの投稿は編集できません。"
  end

  def destroy
    @post = Current.user.posts.find(params[:id])
    @post.destroy

    redirect_to  public_mypage_path, notice: "投稿を削除しました。"
  rescue ActiveRecord::RecordNotFound
    redirect_to public_posts_path, alert: "他のユーザーの投稿は削除できません。"
  end

  private

  def post_params
    params.require(:post).permit(
      :image,
      :title,
      :introduction,
      :ingredients,
      :how_to_make,
      :target_age,
      :allergy
    )
  end
end