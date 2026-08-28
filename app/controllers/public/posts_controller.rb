class Public::PostsController < ApplicationController
  before_action :require_authentication

  def new
    @post = Current.user.posts.build
    @joined_groups = Current.user.joined_groups
  end

  def create
    @post = Current.user.posts.build(post_params)

    if @post.save
      redirect_to public_post_path(@post), notice: "投稿しました。"
    else
      @joined_groups = Current.user.joined_groups
      render :new, status: :unprocessable_entity
    end
  end

  def index
    joined_group_ids = Current.user
                             .group_memberships
                             .where(status: "approved")
                             .pluck(:group_id)
    
    @posts = Post
      .includes(:user, :group)
      .where(
        "visibility = :public OR (visibility = :group AND group_id IN (:group_ids))",
        public: "public",
        group: "group",
        group_ids: joined_group_ids.presence || [-1]
      )
      .order(created_at: :desc)
end

  def show
    @post = Post.includes(:user, :group, comments: :user).find(params[:id])

    if @post.visibility == "group"
      unless @post.group && @post.group.members.exists?(Current.user.id)
        redirect_to public_posts_path,
                    alert: "この投稿を閲覧するにはコミュニティーへの参加が必要です。"
        return
      end
    end
  end

  def edit
    @post = Current.user.posts.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to public_posts_path,
                alert: "他のユーザーの投稿は編集できません。"
  end

  def update
    @post = Current.user.posts.find(params[:id])

    if @post.update(post_params)
      redirect_to public_post_path(@post),
                  notice: "投稿を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to public_posts_path,
                alert: "他のユーザーの投稿は編集できません。"
  end

  def destroy
    @post = Current.user.posts.find(params[:id])
    @post.destroy

    redirect_to public_mypage_path,
                notice: "投稿を削除しました。"
  rescue ActiveRecord::RecordNotFound
    redirect_to public_posts_path,
                alert: "他のユーザーの投稿は削除できません。"
  end

  private

  def post_params
    params.require(:post).permit(
      :title,
      :introduction,
      :ingredients,
      :how_to_make,
      :target_age,
      :allergy,
      :image,
      :visibility,
      :group_id
    )
  end
end