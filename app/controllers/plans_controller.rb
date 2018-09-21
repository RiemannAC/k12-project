class PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :show, :update, :destroy]

  def index
    @user = User.find(params[:user_id])
    @plan = @user.plans.all
  end

  def show
    @user = User.find(params[:user_id])
    if params[:user_id]
      @plan = @user.materials.find(params[:id])
      if params[:plan_id]
        @teachingfile = plan.teachingfiles.find(params[:id])
      else
        @teachingfile = Teachingfile.new
      end
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
      flash[:notice] = "成功新增資料夾【#{plan.plan_folder_name}】"
      redirect_to user_plans_path
    else
      flash[:alert] = "資料夾新增失敗"
      render :new
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @plan = @user.plans.find(params[:id])
  end

  def update
    if@ @plan.update(plan_params)
      flash[:notice] = "更新教案資料夾設定"
      redirect_to user_plan_path(@user, @plan)
    else
      flash.now[:alert] = "未能成功更新"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @plan = @user.plans.find(params[:id])
    @plan.destroy
    redirect_to user_plans_path
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
