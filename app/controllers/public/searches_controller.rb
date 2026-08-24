class Public::SearchesController < ApplicationController
  before_action :require_authentication

  def index
    @keyword = params[:keyword]
    @target_age = params[:target_age]
    @search_type = params[:search_type]

    if @search_type == "user"

      @users = User.where(
        "name LIKE ?",
        "%#{@keyword}%"
      )

    elsif @search_type == "post"

      @posts = Post.includes(:user)
                   .order(created_at: :desc)

      # 対象年齢
      if @target_age.present?
        @posts = @posts.where(
          target_age: @target_age
        )
      end

      # キーワード
      if @keyword.present?
        keyword = "%#{@keyword}%"

        @posts = @posts.where(
          "title LIKE :keyword
           OR introduction LIKE :keyword
           OR ingredients LIKE :keyword
           OR how_to_make LIKE :keyword",
          keyword: keyword
        )
      end

    end
  end
end