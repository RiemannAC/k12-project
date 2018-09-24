class TopicsController < ApplicationController
  def create
    @user = current_user
    @subject = @user.subjects.find(params[:subject_id])
    @topic = @subject.topics.create(topic_params)

    respond_to do |format|
      if @topic.save!
        format.html{redirect_to root_path,notice:"成功新增教學主題" }
        format.json{render :show, status: :created, location: @topic}
        #format.js
      else
        format.html{render :new}
        format.json{render json: @topic.errors,status: :unprocessable_entity}
        #format.js
      end
    end 
  end

  private
  def topic_params
    params.require(:topic).permit(:name,:subject_id,:feedback)
  end
end
