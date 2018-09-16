class AimsController < ApplicationController
  def create
    @teachingschedule= Teachingschedule.find(params[:teachingschedule_id])
    @aim = @teachingschedule.aims.new(aim_params)

    respond_to do |format|
      if @aim.save
        format.html{redirect_to classroom_url(@aim.teachingschedule.classroom),notice:"成功新增一個教學計劃" }
        format.json{render :show, status: :created, location: @aim}
        format.js
      else
        format.html{render :new}
        format.json{render json: @aim.errors,status: :unprocessable_entity}
        format.js
      end
    end 
  end

  def update
    @classroom= Classroom.find(params[:classroom_id])
    @teachingschedule = @classroom.teachingschedules.find(params[:id])
    respond_to do |format|
      if @teachingschedule.update(teachingschedule_params)
        format.html{redirect_to classroom_url(@teachingschedule.classroom),notice:"成功更新教學計劃" }
        format.json{render :show, status: :ok, location: @teachingschedule}  
        format.js 
      else
        format.html{render :edit}
        format.json{render json: @teachingschedule.errors,status: :unprocessable_entity} 
        format.js
      end
    end
  end

  def destroy
    @classroom= Classroom.find(params[:classroom_id])
    @teachingschedule = @classroom.teachingschedules.find(params[:id])
    @teachingschedule.destroy
    respond_to do |format|
      format.html{redirect_to classroom_url(@teachingschedule.classroom),notice:"成功刪除一個教學計劃" }
      format.json{head :no_content}  
      
    end
  end

  private
  def aim_params
    params.require(:aim).permit(:title,:classroom_id,:accessment,:teachingschedule_id)
  end
end
