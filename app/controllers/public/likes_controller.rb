class Public::LikesController < ApplicationController
  before_action :require_authentication

  def index
    @posts = Current.user.likes
                      .includes(:post)
                      .map(&:post)
                      .sort_by { |post| -post.created_at.to_i }
  end

  def create
    @post = Post.find(params[:post_id])

    unless Current.user.likes.exists?(post: @post)
      Current.user.likes.create!(post: @post)
    end

    respond_to do |format|
      format.html { redirect_to public_post_path(@post) }
      format.turbo_stream
    end
  end

  def destroy
    @post = Post.find(params[:post_id])

    like = Current.user.likes.find_by(post: @post)
    like&.destroy

    respond_to do |format|
      format.html { redirect_to public_post_path(@post) }
      format.turbo_stream
    end
  end
end