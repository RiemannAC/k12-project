class PlansController < ApplicationController
  before_action :set_plan, only: [:edit, :show, :update, :destroy]

  def index
    
  end

  def new
    @plan = Plan.new
  end
 
  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      flash[:notice] = "teaching-plan file was successfully created"
      redirect_to root_path
    else
      flash.now[:alert] = "teaching-plan file was failed to create"
      render :new
    end
  end

  def show
  
    if params[:plan_id]
      @teachingfile = @plan.teachingfiles.find(params[:id])
    else
      @teachingfile = Teachingfile.new
    end  
  end

  def update
    if @plan.update(plan_params)
      flash[:notice] = "更新教案資料夾設定"
      redirect_to plan_path(@plan)
    else
      flash.now[:alert] = "未能成功更新"
      render :edit
    end
  end

  def destroy
    
  end


  private

  def plan_params
    params.require(:plan).permit(:plan_folder_name,:subject_tag_id)
  end

  def set_plan
    @plan = Plan.find(params[:id])
  end

end
