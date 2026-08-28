class Public::GroupMembershipsController < ApplicationController
  before_action :require_authentication

  def create
    @group = Group.find(params[:group_id])

    membership = @group.group_memberships.find_or_initialize_by(
      user: Current.user
    )

    if membership.save
      redirect_to public_group_path(@group),
                  notice: "コミュニティーに参加しました。"
    else
      redirect_to public_group_path(@group),
                  alert: "コミュニティーに参加できませんでした。"
    end
  end

  def destroy
    @group = Group.find(params[:group_id])

    membership = @group.group_memberships.find_by(
      user: Current.user
    )

    membership&.destroy

    redirect_to public_group_path(@group),
                notice: "コミュニティーから退出しました。"
  end
end