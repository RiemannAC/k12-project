class MaterialsController < ApplicationController
  before_action :set_material, only: [ :edit, :show, :update, :destroy]
  
  def index 
    @user = User.find(params[:user_id])
    @material = @user.materials.order(created_at: :desc)
  end

  def show
    @user = User.find(params[:user_id])
    if params[:user_id]
      @material = @user.materials.find(params[:id])
      if params[:material_id]
        @teachingfile = @material.teachingfiles.find(params[:id])
      else
        @teachingfile = Teachingfile.new
      end
    end
  end


  def new
    @user = User.find(params[:user_id])
    @material = @user.materials.new
  end 

  def create
    @user = User.find(params[:user_id])
    @material = @user.materials.new(material_params)
    if @material.save
      flash[:notice] = "成功新增資料夾【#{@material.mtrial_folder_name}】"
      redirect_to user_materials_path
    else
      flash.now[:alert] = "資料夾新增失敗！"
      render :new
    end   
  end

  def edit
    @user = User.find(params[:user_id])
    @material = @user.materials.find(params[:id])   
  end 


  def update
    if @material.update(material_params)
      flash[:notice] = "更新教案資料夾設定"
      redirect_to user_materials_path
    else
      flash.now[:alert] = "未能成功更新"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @material = @user.materials.find(params[:id])    
    @material.destroy
    redirect_to user_materials_path
    flash[:alert] = "#{@material.mtrial_folder_name}資料夾已刪除"
  end

  private

  def material_params
    params.require(:material).permit(:mtrial_folder_name,:user_id,:subject_tag_id)
  end

  def set_material
    @material = Material.find_by(params[:material_id])
  end
end
