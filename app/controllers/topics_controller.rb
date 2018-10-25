class TopicsController < ApplicationController
  
  def show
    @user = current_user
    @subjects = @user.subjects
    @materials = @user.materials #.order(subject_tag_id: :asc)
    @plans = @user.plans #.order(created_at: :desc)
    # nested each do 下層有資料才顯示的判定條件？見 topics_show partial 兩端資料對接的條件設定
    # @subject_tags navbar 有使用需求，設定在 application_controller 內
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:id])
    @addfiles = @topic.addfiles.all
  end  
 
  def create
    @user = current_user
    @classroom = @user.classrooms.find(params[:classroom_id])
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
    @user = current_user
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:id])
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
    @user = current_user
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:id])
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
  def topic_params
    params.require(:topic).permit(:name,:subject_id,:classroom_id,:start_time,:end_time,:feedback)
  end
end
