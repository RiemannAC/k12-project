class AimsController < ApplicationController
  def create
    @user = current_user
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:topic_id])
    @aim = @topic.aims.create(aim_params) 

    respond_to do |format|
      if @aim.save
        #format.html{redirect_to user_subject_url(@user,@subject),notice:"成功新增教學目標" }
        #format.json{render :show, status: :created, location: @aim}
        format.js
      else
        #format.html{render :new}
        #format.json{render json: @aim.errors,status: :unprocessable_entity}
        format.js 
      end
    end 
  end

  def edit
    @user = current_user
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:topic_id])
    @aim = @topic.aims.find(params[:id])
  end

  def update
    @user = current_user
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:topic_id])
    @aim = @topic.aims.find(params[:id])
    respond_to do |format|
      if @aim.update(aim_params)
        #format.html{redirect_to user_subject_url(@user,@subject),notice:"成功更新教學目標" }
        #format.json{render :show, status: :ok, location: @aim}  
        format.js
      else
        #format.html{render :edit}
        #format.json{render json: @aim.errors,status: :unprocessable_entity} 
        format.js
      end
    end
  end

  def destroy
    @user = current_user
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:topic_id])
    @aim = @topic.aims.find(params[:id])   
    @aim.destroy
    respond_to do |format|
      #format.html{redirect_to user_subject_url(@user,@subject),notice:"成功刪除教學目標" }
      #format.json{head :no_content}  
      format.js
    end
  end

  private
  def aim_params
    params.require(:aim).permit(:name,:topic_id,:status)
  end

end
