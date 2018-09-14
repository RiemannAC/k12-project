class TeachingschedulesController < ApplicationController
  def create
    @classroom= Classroom.find(params[:classroom_id])
    @teachingschedule = @classroom.teachingschedules.new(teachingschedule_params)

    respond_to do |format|
      if @teachingschedule.save
        format.html{redirect_to classroom_url(@teachingschedule.classroom),notice:"成功新增一個教學計劃" }
        format.json{render :show, status: :created, location: @teachingschedule}
      else
        format.html{render:new}
        format.json{render json: @teachingschedule.errors,ststus: :unprocessable_entity}
      end
    end 
  end

  private
  def teachingschedule_params
    params.require(:teachingschedule).permit(:theme,:classroom_id,:feedback)
  end
end
