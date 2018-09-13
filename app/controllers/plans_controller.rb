class PlansController < ApplicationController
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
    @plan = Plan.find(params[:id])
    @topics = Topic.order(created_at: :desc)
    
    if params[:plan_id]
      @teachingfile = @plan.teachingfiles.find(params[:id])
    else
      @teachingfile = Teachingfile.new
    end  
  end

  private

  def plan_params
    params.require(:plan).permit(:title,:topic_id)
  end
end
