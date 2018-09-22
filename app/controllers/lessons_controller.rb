class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  # before_action :set_subject_of_lesson, only: [:edit]

  before_action :set_user, only: [:index, :show, :list]
  before_action :set_lessons, only: [:index, :list]

  before_action :authenticate_user!, except: [:index, :show, :list]
  before_action :authenticate_author, except: [:index, :show, :list]

  def index 
    @user = current_user 
    
  end

  def list 
  end

  # 新增一堂課，預設 end_time 現在時間一小時後，period "Does not repeat"
  def new
    user = current_user
    subject = user.subjects.create!(name: "未分類", start_time: Time.now)
    topic = subject.topics.create!(name: "未分類")
    @lesson = topic.lessons.new(:end_time => 1.hour.from_now, :period => "Does not repeat")
    # render :json => {:form => render_to_string(:partial => 'form')}
  end
  
  # 此處 period 是 :commit 參數，不是 lesson table 的欄位
  def create
    if params[:lesson][:period] == "Does not repeat"
      # 新增權限已確認
      user = current_user
      @subject = user.subjects.create!(name: "未分類", start_time: Time.now)
      @topic = @subject.topics.create!(name: "未分類") #1
      @lesson = @topic.lessons.new(lesson_params)
      @lesson.end_time = @lesson.start_time + 1.hour
    else
      # 編輯中
      # lesson = @subjects = Subject.new(:frequency => params[:lesson][:frequency], :period => params[:lesson][:repeats], :start_time => params[:lesson][:start_time], :end_time => params[:lesson][:end_time], :all_day => params[:lesson][:all_day])
      @lesson = Subject.new(lesson_params)
    end
    if @lesson.save
      # render :nothing => true
      flash[:notice] = "Lesson was successfully created"
      redirect_to user_lessons_path
      # redirect_to lessons_path
    else
      #render :text => lesson.errors.full_messages.to_sentence, :status => 422
      flash.now[:alert] = "Lesson was failed to created"
      render :new
    end
  end

  def edit
    lesson = Lesson.find_by_id(params[:id])
    # 不用路由 params 也可將 id 傳入，但括號內不可使用"實例變數"
    topic = Topic.find_by_id(lesson.topic_id)
    @subject = Subject.find_by_id(topic.subject_id)
    # 測試用 render :json => { :form => render_to_string(:partial => 'edit_form') }
  end

  def update
    # @lesson = Lesson.find_by_id(params[:lesson][:id])
    if params[:lesson][:commit_button] == "更新之後的課程"
      # 以下編輯中，待接新增科目
      @lessons = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @lesson.update_events(@events, event_params)
    elsif params[:lesson][:commit_button] == "更新整學期的課程"
      # 以下編輯中，待接新增科目
      @lessons = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @lesson.update_events(@events, event_params)
    else # "更新這堂課" 編輯完成
      @lesson.attributes = lesson_params
      @lesson.save
      flash[:notice] = "Lesson was successfully updated"
      redirect_to user_lessons_path
    end
  end
  
  def destroy
    # 以下編輯中，待接新增科目
    if params[:delete_all] == '刪除整學期的課程'
      @lesson.event_series.destroy
    # 以下編輯中，待接新增科目
    elsif params[:delete_all] == '刪除之後的課程'
      @lessons = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @lesson.event_series.events.delete(@events)
    # 刪除這堂課 編輯完成
    else
      @lesson.destroy
      flash[:alert] = "Lesson was successfully deleted"
      redirect_to user_lessons_path
    end
  end

  private

    # 設定使用者
    def set_lesson
      @lesson = Lesson.find_by_id(params[:id])
    end

    # 顯示使用者所擁有的課表
    def set_lessons
      # pluck 方法，輸出 array，第一步就用 each do 展開的話，後面就難收拾了
      subject_ids = Subject.where(user_id: @user).pluck(:id)
      # 疊代
      topic_ids = Topic.where(subject_id: subject_ids).pluck(:id)
      # topic_id 欄位，輸入 id array，輸出 lessons 的 ActiveRecord，不需要用 id 各別宣告再收集起來。
      @lessons = Lesson.where(topic_id: topic_ids)
    end

    # 刪除整學期的課程，待利用
    def set_subject_of_lesson
    lesson = Lesson.find_by_id(params[:id])
    # 注意：不用路由 params 也可將 id 傳入，但括號內不可使用"實例變數"。此方法可避免巢狀路由過於複雜。
    topic = Topic.find_by_id(lesson.topic_id)
    @subject = Subject.find_by_id(topic.subject_id)
    end

    def set_user
      @user = User.find_by_id(params[:user_id])
    end

    def lesson_params
      params.require(:lesson).permit('name', 'start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)', 'end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)', 'all_day', 'period', 'frequency', 'commit_button')
    end

end