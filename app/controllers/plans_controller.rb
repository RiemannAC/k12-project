class PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :show, :update, :destroy]

  def index
    @user = current_user
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
