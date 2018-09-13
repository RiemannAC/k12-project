class ClassroomsController < ApplicationController 
  def show
    @classroom = Classroom.find(params[:id])
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @plans = Plan.order(created_at: :desc)
    @materials =Material.order(created_at: :desc)
    @topics = Topic.order(created_at: :desc)
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
 