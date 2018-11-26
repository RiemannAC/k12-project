class AimsController < ApplicationController
  before_action :set_user
  before_action :set_classroom
  before_action :set_topic
  before_action :set_aim, only: [:edit, :update, :destroy]

  def create
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
        flash[:alert]= @aim.errors.full_messages.to_sentence
        # 要重新整理頁面才會顯示 > 再加 redirect
        redirect_back fallback_location: root_path
      end
    end 
  end

  def edit
  end

  def update
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
    @aim.destroy
    respond_to do |format|
      #format.html{redirect_to user_subject_url(@user,@subject),notice:"成功刪除教學目標" }
      #format.json{head :no_content}  
      format.js
    end
  end

  private
  def set_user
    @user = current_user
  end

  def set_classroom
    @classroom = @user.classrooms.find(params[:classroom_id])
  end

  def set_topic
    @topic = @classroom.topics.find(params[:topic_id])
  end

  def set_aim
    @aim = @topic.aims.find(params[:id])
  end

  def aim_params
    params.require(:aim).permit(:name,:topic_id,:status)
  end

end
