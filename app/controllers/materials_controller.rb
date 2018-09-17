class MaterialsController < ApplicationController
  def index
    
  end

  def new
    @material = Material.new 
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      flash[:notice] = "teaching-material file was successfully created"
      redirect_to root_path
    else
      flash.now[:alert] = "teaching-material file was failed to create"
      render :new
    end
  end

  def show
    @material = Material.find(params[:id])
    @topics = Topic.order(created_at: :desc)
    
    if params[:material_id]
      @teachingfile = @material.teachingfiles.find(params[:id])
    else
      @teachingfile = Teachingfile.new
    end
    
  end

  private

  def material_params
    params.require(:material).permit(:title,:topic_id)
  end
end
