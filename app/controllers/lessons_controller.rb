class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  # before_action :set_subject_of_lesson, only: [:edit]

  before_action :set_user, only: [:index, :show, :list]
  before_action :set_lessons, only: [:index, :list]

  before_action :authenticate_user!# index 改設定為 root，巢狀內的 root 必需加的設定
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

      # 使用 new 或 create 都會多出一組 s t
      # 重覆生成多餘的一組 subject 與 topic 資料，但有一組完整的 s t l 在前端顯示資料是正常的
      @subject = user.subjects.new(name: "未分類") # 時間在資料庫的時區是 +0
      @topic = @subject.topics.new(name: "未分類")

      @lesson = @topic.lessons.new(lesson_params)
      @lesson.end_time = @lesson.start_time + 1.hour

      # 事後修改有關聯的 subject 的屬性 => 無報錯但資料庫沒有更新 => 老問題，有更新動作，但值沒寫入
      # Subject.last.update_attributes(name: params[:lesson][:name], start_time: params[:lesson][:start_time])

      # 刪除第一組多餘資料 OK。讓我們突破路由和回呼的限制操爆 server 吧
      Subject.last(2).first.destroy
    else #params[:lesson][:period] == "Repeat weekly"
      user = current_user

      # 過渡資料
      @subject = user.subjects.new(name: "未分類", start_time: params[:lesson][:start_time]) # 時間在資料庫的時區是 +0
      @topic = @subject.topics.new(name: "未分類")


      start = Time.new(params[:lesson]['start_time(1i)'],params[:lesson]['start_time(2i)'],params[:lesson]['start_time(3i)'],params[:lesson]['start_time(4i)'],params[:lesson]['start_time(5i)'])

      # 判斷 break point
      date_year = params[:lesson]['start_time(1i)'].to_i
      date_month = params[:lesson]['start_time(2i)'].to_i
      if date_month.between?(7,12)
        semester = Time.new(date_year,7,1)..Time.new(date_year + 1,1,31).end_of_day # 沒加 end_of_day 最後一天的事件會漏掉
      elsif  date_month.between?(1,1)
        semester = Time.new(date_year - 1,7,1)..Time.new(date_year,1,31).end_of_day
      else
        semester = Time.new(date_year,2,1)..Time.new(date_year,6,30).end_of_day
      end

       i = 0
      loop do
        @lesson = @topic.lessons.new(lesson_params)
        @lesson.start_time = start
        @lesson.end_time = start + 1.hour
        @lesson.save
        start += 1.week
        i += 1
        break if start > semester.end
      end

      Subject.last(2).first.destroy # 跑迴圈還是只會多一筆資料，刪除第一筆多餘資料 OK
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

    def lesson_params
      params.require(:lesson).permit(:name, :start_time,'start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)', 'end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)', :period, :frequency, :commit_button)
    end

end