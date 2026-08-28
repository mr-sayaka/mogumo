class HomesController < ApplicationController
  allow_unauthenticated_access only: [:top, :about]

  def top
    @posts = Post.includes(:user, :group, image_attachment: :blob)
                .where(visibility: "public")
                .order(created_at: :desc)
  end

  def about
  end
end
