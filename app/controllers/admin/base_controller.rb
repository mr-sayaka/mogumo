class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :require_admin_authentication

  private

  def require_admin_authentication
    return if Current.admin

    redirect_to new_admin_session_path
  end
end