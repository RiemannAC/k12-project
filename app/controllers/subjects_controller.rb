class SubjectsController < ApplicationController
  def index
    
  end

  def new
    @subject = @user.subjects.new
  end

  def create
    @user = current_user
    @subject = @user.subjects.new(subject_params)
    
    if @subject.save
      redirect_to user_subjects_path(@user)
      flash[:notice] = "班級新建成功 :)"
    else
      flash.now[:alert] = "新建失敗，再試一次！"
      render :new
    end
  end
 
  def show
    @user = current_user
    @subject = @user.subjects.find(params[:id])
    @ttopic = Ttopic.new
    @ttopics = @subject.ttopics.all

    if params[:subject_id]
      @ttopic = @subject.ttopics.find(params[:topic_id])
    end
    
    @topic = Topic.new
    @topics = @subject.topics.all

    if params[:subject_id]
      @topic= @subject.topics.find(params[:topic_id])
      @aim = @topic.aims.find(params[:id])     
    end

    @subject_range = @subject.end_time.yday-@subject.start_time.yday + 1
    if @subject_range%7 != 0
      @project_weeks = @subject_range/7 + 1
    else
      @project_weeks = @subject_range/7
    end
    return @project_weeks

    @startdate = Date.parse(@subject.start_time.strftime("%Y-%m-%d"))
    @enddate = Date.parse(@subject.end_time.strftime("%Y-%m-%d"))
    @week_firsts = (startdate..enddate).select(&:sunday?).map(&:to_s).to_a
    @week_lasts = (startdate..enddate).select(&:saturday?).map(&:to_s).to_a

  end

  def edit
    @user = current_user
    @subject = @user.subjects.find(params[:id])
  end

  def update
    @subject = @user.subjects.find(params[:id])
    if @subject.update(subject_params)
      flash[:notice] = "更新班級設定"
      redirect_to user_subjects_path
    else
      flash.now[:alert] = "未能成功更新"
      render :edit
    end
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