class PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :show, :update, :destroy]

  def index
  end

  def show
    
    if params[:plan_id]
      @teachingfile = @material.teachingfiles.find(params[:id])
    else
      @teachingfile = Teachingfile.new
    end
  end

  def new
    @user = User.find(params[:user_id])
    @plan = @user.plans.new
  end

  def create
    @user = User.find(params[:user_id])
    @plan = @user.plans.new(plan_params)
    if @plan.save
      flash[:notice] = "已新增了一個#{@plan.plan_folder_name}資料夾"
      redirect_to user_plans_path(current_user)
    else
      flash[:alert] = "新增教案資料夾失敗"
      render :new
    end
  end

  def update
    if @plan.update(plan_params)
      flash[:notice] = "更新教案資料夾設定"
      redirect_to user_plans_path(current_user)
    else
      flash.now[:alert] = "未能成功更新"
      render :edit
    end
  end

  def destroy
    @plan.destroy
    redirect_to user_plans_path(current_user)
    flash[:alert] = "#{@plan.plan_folder_name}資料夾已刪除"
  end


  private

  def plan_params
    params.require(:plan).permit(:plan_folder_name,:subject_tag_id)
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end

end
