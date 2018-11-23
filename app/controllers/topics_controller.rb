class TopicsController < ApplicationController
  before_action :set_user, only: [:show, :create, :update, :destroy]
  before_action :set_classroom, only: [:show, :create, :update, :destroy]
  before_action :set_topic, only: [:show, :update, :destroy]

  def show
    @subjects = @user.subjects
    @materials = @user.materials
    @plans = @user.plans
    @addfiles = @topic.addfiles.all
  end  
 
  def create
    @topic = @classroom.topics.create(topic_params)

    #respond_to do |format|
      if @topic.save
        #format.html{redirect_to user_classroom_url(@user,@classroom),notice:"成功新增教學主題" }
        #format.json{render :show, status: :created, location: @topic}
        #format.js
        flash[:notice]= "成功新增教學主題"
        redirect_back fallback_location: root_path
      else
        #format.html{redirect_to user_classroom_url(@user,@classroom),alert:"新增失敗，請完全填妥教學計劃表格資訊"}
        #format.json{render json: @topic.errors,status: :unprocessable_entity}
        #format.js
        flash[:alert]= "新增失敗，請完全填妥教學計劃表格資訊"
        redirect_back fallback_location: root_path
      end
    #end 
  end 

  def update
    #respond_to do |format|
      if @topic.update(topic_params)
        #format.html{redirect_to user_subject_url(@user,@subject),notice:"成功更新教學計劃" }
        #format.json{render :show, status: :ok, location: @topic}  
        #format.js 
        flash[:notice]= "成功更新教學主題"
        redirect_back fallback_location: root_path
      else
        #format.html{redirect_to user_subject_url(@user,@subject),alert:"更新失敗，請完全填妥教學計劃表格資訊"}
        #format.json{render json: @topic.errors,status: :unprocessable_entity} 
        #format.js
        flash[:alert]= "新增失敗，請完全填妥教學計劃表格資訊"
        redirect_back fallback_location: root_path
      end
    #end
  end

  def destroy
    @topic.destroy
    #respond_to do |format|
      #format.html{redirect_to user_subject_url(@user,@subject),notice:"成功刪除一個教學計劃" }
      #format.json{head :no_content}  
      #format.js
    #end
    flash[:notice]= "成功刪除一個教學單元"
    redirect_back fallback_location: root_path
  end


  private
  def set_user
    @user = current_user
  end

  def set_classroom
    @classroom = @user.classrooms.find(params[:classroom_id])
  end

  def set_topic
    @topic = @classroom.topics.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:name,:subject_id,:classroom_id,:start_time,:end_time,:feedback)
  end
end
