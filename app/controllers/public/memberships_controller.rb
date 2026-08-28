class Public::MembershipsController < ApplicationController
  before_action :require_authentication

  def create
    @group = Group.find(params[:group_id])

    @membership = GroupMembership.find_or_initialize_by(
      group: @group,
      user: Current.user
    )

    @membership.status = "approved"

    if @membership.save
      redirect_to public_group_path(@group),
                  notice: "コミュニティーに参加しました。"
    else
      redirect_to public_group_path(@group),
                  alert: "コミュニティーへの参加に失敗しました。"
    end
  end

  def destroy
    @group = Group.find(params[:group_id])

    @membership = GroupMembership.find_by(
      group: @group,
      user: Current.user
    )

    @membership&.destroy

    redirect_to public_group_path(@group),
                notice: "コミュニティーから退出しました。"
  end
end