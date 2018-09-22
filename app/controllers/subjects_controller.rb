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


  private

  def subject_params
    params.require(:subject).permit(:name, :classroom, :grade)    
  end
end