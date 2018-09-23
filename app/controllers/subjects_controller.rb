class SubjectsController < ApplicationController
  def index
    
  end

  def new
    @subject = @user.subjects.new
  end

  def create
    @subject = @user.subjects.new(subject_params)
    @user = current_user
    if @subject.save
      redirect_to user_subjects_path(@user)
      flash[:notice] = "班級新建成功 :)"
    else
      flash.now[:alert] = "新建失敗，再試一次！"
      render :new
    end
  end

  def show
    @subject = @user.subjects.find(params[:id])
  end

  def edit
    @subject = @user.subjects.find(params[:id])
  end

  def update
    @subject = @user.subjects.find(params[:id])
  end

  def destroy
    @subject = @user.subjects.find(params[:id]) 
    @subject.destroy
    redirect_to user_subjects_path(@user)
    flash[:alert] = "#{@subject.classroom}學期計劃已被刪除"
  end


  private

  def subject_params
    params.require(:subject).permit(:name, :classroom, :grade, :students, :start_time, :end_time,:user_id)    
  end
end