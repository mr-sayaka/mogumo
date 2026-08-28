class Admin::AdminsController < Admin::BaseController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  def index
    @admins = Admin.order(created_at: :desc)
  end

  def show
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to admin_admins_path, notice: "管理者を登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @admin.update(admin_params)
      redirect_to admin_admin_path(@admin), notice: "管理者情報を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if Admin.count <= 1
      redirect_to admin_admins_path,
                  alert: "最後の管理者は削除できません。"
      return
    end

    @admin.destroy
    redirect_to admin_admins_path, notice: "管理者を削除しました。"
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(
      :name,
      :email_address,
      :password,
      :password_confirmation
    )
  end
end