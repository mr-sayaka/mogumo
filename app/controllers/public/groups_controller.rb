class Public::GroupsController < ApplicationController
  before_action :require_authentication

  def index
    @groups = Group.includes(:admin).order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
    
    @membership = @group.group_memberships.find_by(
      user: Current.user
    )

    @posts = @group.posts
                 .includes(:user)
                 .where(visibility: "group")
                 .order(created_at: :desc)
  end

end