class Admin::DashboardsController < Admin::BaseController
  def index
    @admin_count = Admin.count
    @comment_count = Comment.count
  end
end