class MaterialsController < ApplicationController
  before_action :set_material, only: [ :edit, :show, :update, :destroy]
  
  def index 
    # @user = current_user 用這個更換 user_id 看到的都是一樣的東西，有權限需求另外設定即可
    @user = User.find_by_id(params[:user_id])

    @materials = @user.materials.order(created_at: :desc)
    # 瀏覽別人的頁面要把"新增按鈕"蓋掉
    @material = current_user.materials.new


    subject_tag_ids = @user.materials.pluck(:subject_tag_id)
    @subject_tags = SubjectTag.where(id: subject_tag_ids)
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

  def create
    @user = User.find(params[:user_id])
    @material = @user.materials.new(material_params)
    if @material.save
      flash[:notice] = "成功新增資料夾【#{@material.mtrial_folder_name}】"
      redirect_to user_materials_path
    else
      flash.now[:alert] = "請確定選擇科目及填上主題／單元名稱！"
      render :index
    end   
  end

  def update 
    @user = User.find(params[:user_id])
    @material = @user.materials.find(params[:id])  
    if @material.update(material_params)
      flash[:notice] = "更新教材資料夾設定"
      redirect_to user_material_path(@user, @material)
    else
      flash[:alert] = "更新失敗，請確定填上主題／單元名稱！"
      redirect_to user_material_path(@user, @material)
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
