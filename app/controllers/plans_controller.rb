class PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :show, :update, :destroy]

  def index
    @user = current_user
    @plans = @user.plans.order(created_at: :desc)
  end 

  def new 
    @user = User.find(params[:user_id])
    @plan = @user.plans.new
  end

  def create
    @user = User.find(params[:user_id])
    @plan = @user.plans.new(plan_params)

    @plan.user = current_user
    if @plan.save!
      redirect_to user_plans_path(current_user,@plans)
    else
      flash[:alert] = "新增教案資料夾失敗"
      render :new
    end 
  end 

  def show
    @user = User.find(params[:user_id])
    if params[:user_id]
      @plan = @user.plans.find(params[:id])
      if params[:plan_id]
        @teachingfile = @plan.teachingfiles.find(params[:id])
      else
        @teachingfile = Teachingfile.new
      end
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @plan = @user.plans.find(params[:id])     
  end

  def update
    @user = User.find(params[:user_id])
    @plan = @user.plans.find(params[:id]) 
    if @plan.update(plan_params)
      flash[:notice] = "更新教案資料夾設定"
      redirect_to user_plans_path
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
    params.require(:plan).permit(:user_id,:plan_folder_name,:subject_tag_id)
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def set_user
      @user = User.find_by_id(params[:user_id])
    end

end
