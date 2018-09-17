class PlansController < ApplicationController
  def index
    @subject_tags = SubjectTag.order(created_at: :desc)
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
    @subject_tags = SubjectTag.order(created_at: :desc)
    @plan = Plan.find(params[:id])
     
    if params[:plan_id]
      @teachingfile = @plan.teachingfiles.find(params[:id])
    else
      @teachingfile = Teachingfile.new
    end  
  end

  private

  def plan_params
    params.require(:plan).permit(:plan_folder_name,:subject_tag_id)
  end

end
