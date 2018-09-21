class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  # before_action :set_subject_of_lesson, only: [:edit]

  before_action :set_user, only: [:index, :show, :list]
  before_action :set_lessons, only: [:index, :list]

  before_action :authenticate_user!, except: [:index, :show, :list]
  before_action :authenticate_author, except: [:index, :show, :list]

  # after_create :set_subject_name # undefined method `after_create' for LessonsController:Class Did you mean? after_action
  after_action :set_subject_name, only: [:create]

  def index
  end

  def list
  end

  # 新增一堂課，預設 end_time 現在時間一小時後，period "Does not repeat"
  def new
    user = current_user
    subject = user.subjects.create!(name: "未分類", start_time: Time.now)
    # subject = user.subjects.create!(name: @lesson.name, start_time: Time.now) # name 還是傳送給 lesson
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
    else #params[:lesson][:period] == "Repeat weekly"
      user = current_user
      @subject = user.subjects.create!(name: "未分類", start_time: Time.now) # time 有誤待修
      @topic = @subject.topics.create!(name: "未分類")

      # start = params[:lesson][:start_time] # start = nil 接收不到 params
      # start_array = []
      # start_array << start
      # Date.today.beginning_of_day
      # start = Date.new
      # 先成一個實例，再用 start 接收 start_time => 沒效第三個以後和第二個同時間
      # 以上為失敗寫法
      # 如何和表單回傳的 start_time 同步？
      start = Time.new(2018,9,22,8)

      i = 0
      loop do

        @lesson = @topic.lessons.new(lesson_params)
        @lesson.start_time = start          # 成功待確認終點是否正確
        @lesson.end_time = start + 1.hour   # 成功待確認終點是否正確
        @lesson.save
        start += 1.week                     # 成功待確認終點是否正確
        
        i += 1
        break if ( start + 1.week ) > Time.now + 4.week
      end
      # 以上編輯中，此處不可再加最末段的迴圈會造成 AbstractController::DoubleRenderError..
    end
    if @lesson.save
      flash[:notice] = "Lesson was successfully created"
      redirect_to user_lessons_path
    else
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

  def set_subject_name
    # 如何套用 set_subject_of_lesson
    # lesson = Lesson.find_by_id(params[:id])
    lesson = Lesson.last
    topic = Topic.find_by_id(lesson.topic_id)
    subject = Subject.find_by_id(topic.subject_id)
    subject.name = lesson.name
    subject.save
  end

  def lesson_params
    # params.require(:lesson).permit('name', 'start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)', 'end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)', 'all_day', 'period', 'frequency', 'commit_button')
    params.require(:lesson).permit(:name, 'start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)', 'end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)', :period, :frequency, :commit_button)
  end
end