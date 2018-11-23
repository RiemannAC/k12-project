class PlansController < ApplicationController
  before_action :find_user, only: [:index, :show]
  before_action :set_user, only: [:create, :update, :destroy]
  before_action :find_plan, only: [:update, :destroy]
  before_action :set_plan, only: [:edit, :show, :update, :destroy]

  def index
    @plans = @user.plans.order(created_at: :desc)
    # 瀏覽別人的頁面要把"新增按鈕"蓋掉
    @plan = current_user.plans.new
    subject_tag_ids = @user.plans.pluck(:subject_tag_id)
    @subject_tags = SubjectTag.where(id: subject_tag_ids)
  end

  def show
    if params[:user_id]
      @plan = @user.plans.find(params[:id])
      if params[:plan_id]
        @teachingfile = @plan.teachingfiles.find(params[:id])
      else
        @teachingfile = Teachingfile.new
      end
    end
  end

  def create
    @plan = @user.plans.new(plan_params)
    if @plan.save!
      flash[:notice] = "成功新增資料夾【#{@plan.plan_folder_name}】"
      redirect_to user_plans_path(current_user)# @plans 轉 index 不需要加這個，轉址後網址掛一包 active record，危險
    else
      flash[:alert] = "請確定選擇科目及填上主題／單元名稱！"
      render :new
    end 
  end

  def update
    if @plan.update(plan_params)
      flash[:notice] = "更新教案資料夾設定"
      redirect_to user_plans_path
    else
      flash[:alert] = "更新失敗，請確定填上主題／單元名稱！"
      redirect_to user_plan_path(@user, @material)
    end
  end

  def destroy
    @plan.destroy
    redirect_to user_plans_path
    flash[:alert] = "#{@plan.plan_folder_name}資料夾已刪除"
  end

  private

  def find_user
    @user = User.find_by_id(params[:user_id])
  end

  def set_user
    @user = current_user
  end

  def find_plan
    @plan = @user.plans.find(params[:id])
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:user_id,:plan_folder_name,:subject_tag_id)
  end

end
