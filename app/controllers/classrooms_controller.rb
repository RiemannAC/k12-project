class ClassroomsController < ApplicationController 
  def show 
    @classroom = Classroom.find(params[:id])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @topics = Topic.order(created_at: :desc)
  
    @teachingschedule = Teachingschedule.new

    if params[:classroom_id]
      @teachingschedule= @classroom.teachingschedules.find(params[:teachingschedule_id])
      @aim = @teachingschedule.aims.find(params[:id])     
    end
  end 

  def new
    @classroom = Classroom.new
  end

  def create
    @classroom = Classroom.new(classroom_params)
    if @classroom.save
      flash[:notice] = "classroom was successfully created"
      redirect_to root_path
    else
      flash.now[:alert] = "classroom was failed to create"
      render :new
    end
  end

  private

  def classroom_params
    params.require(:classroom).permit(:name,:topic_id)
  end
end
 