class MaterialsController < ApplicationController
  def show
    @subject_tags = SubjectTag.order(created_at: :desc)
    @material = Material.find(params[:id])
    
    if params[:material_id]
      @teachingfile = @material.teachingfiles.find(params[:id])
    else
      @teachingfile = Teachingfile.new
    end
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

  private

  def material_params
    params.require(:material).permit(:mtrial_folder_name,:subject_tag_id)
  end
end
