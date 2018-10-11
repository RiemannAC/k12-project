class ClassroomsController < ApplicationController

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
    # @user = current_user
    # @subject = @user.subjects.find(params[:subject_id])
    # @classroom = @subject.classrooms.find(params[:id])
    # if @classroom.update(classroom_params)
    #   flash[:notice] = "已更新班級資料"
    #   redirect_to root_path
    # else
    #   flash.now[:alert] = "@classroom.errors.full_messages.to_sentence"
    #   render :edit
    # end 
  end

  def destroy
    # @user = current_user
    # @subject = @user.subjects.find(params[:subject_id])
    # @classroom = @subject.classrooms.find(params[:id])
    # if @classroom.destroy
    #   flash[:alert] = "班級已成功刪除"
    #   redirect_to root_path
    # else
    #   flash.now[:alert] = "@classroom.errors.full_messages.to_sentence"
    #   redirect_to root_path
    # end
  end

  private
  def classroom_params
    params.require(:classroom).permit(:name, :grade, :room, :subject_id,:user_id, :start_time, :end_time, :feedback)
  end
end