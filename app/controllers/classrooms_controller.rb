class ClassroomsController < ApplicationController
  def index
    @user = current_user
    @classrooms = @user.classrooms.all
  end

  def show 
    @user = current_user 
    @classroom = @user.classrooms.find(params[:id])

    @topic = Topic.new
    @topics = @classroom.topics.order(created_at: :desc)

    if params[:classroom_id] 
      @topic = @classroom.topics.find(params[:topic_id])
      @aim = @topic.aims.find(params[:id])     
    end
  end
  
  def create
    # @user = current_user
    # @subject = @user.subjects.find(params[:subject_id])
    # @classroom = @subject.classrooms.create(classroom_params)
    # if @classroom.save
    #   flash[:notice] = "已新增班級"
    #   redirect_to root_path
    # else
    #   flash.now[:alert] = "@classroom.errors.full_messages.to_sentence"
    #   render :new
    # end
  end

  def update
    @user = current_user
    @classroom = @user.classrooms.find(params[:id])
    if @classroom.update(classroom_params)
      flash[:notice] = "更新班級設定"
      redirect_to user_classrooms_path
    else
      flash.now[:alert] = "未能成功更新"
      render :edit
    end
  end

  def edit 
    @user = current_user
    @classroom = @user.classrooms.find(params[:id])
  end

  def destroy
    @user = current_user
    @classroom = @user.classrooms.find(params[:id]) 
    @classroom.destroy
    redirect_to user_classrooms_path(@user)
    flash[:notice] = "#{@classroom.name}學期計劃已被刪除"
  end

  private
  def classroom_params
    params.require(:classroom).permit(:name, :grade, :room, :subject_id,:user_id, :start_time, :end_time, :student)
  end
end