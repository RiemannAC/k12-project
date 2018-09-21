class PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :show, :update, :destroy]

  def index
    @user = current_user
    @plans = @user.plans.all
  end

  def new
    @plan = Plan.new
  end

  def create
    @plan = Plan.new(plan_params)
    @plan = @subject_tag.plans.build
    @plan.user = current_user
    if @plan.save!
      redirect_to user_plans_path(current_user)
    else
      flash[:alert] = "新增教案資料夾失敗"
      render :new
    end
  end

  def show
    @plan = Plan.new
    @plans = @user.plans.all
  end
  private

  def plan_params
    params.require(:plan).permit(:plan_folder_name,:subject_tag_id)
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end

  def set_user
      @user = User.find_by_id(params[:user_id])
    end

end
