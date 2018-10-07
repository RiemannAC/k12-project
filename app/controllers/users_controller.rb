class UsersController < ApplicationController

  def show
    @user = current_user
    @subject_count = @user.subjects.count
    if signed_in?
      redirect_to user_lessons_path(current_user)
    else
      redirect_to root_path
    end
  end

  def viewfile
    @user = current_user    
  end

  def edit
    @user = User.find(params[:id])
    unless @user==current_user
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice]="個人資料成功被編輯"
      redirect_to user_path(@user)
    else
      flash[:alert]="未編輯成功，名字不能為空白"
      render :edit
    end
  end
 
  private
  def user_params
    params.require(:user).permit(:avatar,:name,:intro,:email,:job_title,:website)
  end 

end
