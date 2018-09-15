class TeachingschedulesController < ApplicationController

  def show
    @classroom= Classroom.find(params[:classroom_id])
    @teachingschedule = @classroom.teachingschedules.find(params[:id])

  end

  def create
    @classroom= Classroom.find(params[:classroom_id])
    @teachingschedule = @classroom.teachingschedules.new(teachingschedule_params)

    respond_to do |format|
      if @teachingschedule.save
        #format.html{redirect_to classroom_url(@teachingschedule.classroom),notice:"成功新增一個教學計劃" }
        #format.json{render :show, status: :created, location: @teachingschedule}
        format.js
      else
        format.html{render :new}
        format.json{render json: @teachingschedule.errors,status: :unprocessable_entity}
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
  def teachingschedule_params
    params.require(:teachingschedule).permit(:theme,:classroom_id,:feedback)
  end
end
