class MaterialsController < ApplicationController
  before_action :set_material, only: [:edit, :show, :update, :destroy]
  
  def show
    
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

  def update
    
    if @material.update(material_params)
      flash[:notice] = "更新教案資料夾設定"
      redirect_to material_path(@material)
    else
      flash.now[:alert] = "未能成功更新"
      render :edit
    end
  
  end

  private

  def material_params
    params.require(:material).permit(:mtrial_folder_name,:subject_tag_id)
  end

  def set_material
    @material = Material.find(params[:id])
  end
end
