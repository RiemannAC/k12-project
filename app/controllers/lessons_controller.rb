class LessonsController < ApplicationController
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  # before_action :set_subject_of_lesson, only: [:edit]

  # has_and_belongs_to_many
  #before_action :set_subject_of_lesson, only: [:show]

  before_action :set_user, only: [:index, :show, :list]
  before_action :set_lessons, only: [:index, :list]

  before_action :authenticate_user!# index 改設定為 root，巢狀內的 root 必需加的設定
  before_action :authenticate_author, except: [:index, :show, :list]
  before_action :set_author, only: [:new, :create, :edit, :update, :destroy]

  def index
    @user = current_user

    # _to_do_list
    @day = Date.today
    @todos = Lesson.where(event_type: "todo")
  end

  def show
    @classroom = Classroom.new
    @lesson = Lesson.find(params[:id])
    #@classrooms = @subject.classrooms.all

    # has_and_belongs_to_many
    # 回呼關
    @classrooms = Classroom.all
    @subject = Subject.first


    if params[:subject_id]
      @classroom= @subject.classrooms.find(params[:classroom_id])
      @aim = @classroom.aims.find(params[:id])     
    end
  end

  def list
  end

  # 新增一堂課，預設 end_time 現在時間一小時後，period "Does not repeat"
  def new
    # debug：先 create 就多出無用的資料了，用 new
    subject = @user.subjects.new

    # has_and_belongs_to_many
    #classroom = subject.classrooms.new
    classroom = Classroom.new

    @lesson = classroom.lessons.new
    # render :json => {:form => render_to_string(:partial => 'form')}
  end
  
  # 此處 period 是 :commit 參數，不是 lesson table 的欄位
  def create
    if params[:lesson][:period] == "Does not repeat"

      # 時間在資料庫的時區是 +0
      @subject = @user.subjects.find_or_initialize_by(name: params[:lesson][:name])

      # has_and_belongs_to_many
      #@classroom = @subject.classrooms.find_or_initialize_by(name: (params[:lesson][:grade] + params[:lesson][:room]), grade: params[:lesson][:grade], room: params[:lesson][:room])
      @classroom = Classroom.find_or_initialize_by(name: (params[:lesson][:grade] + params[:lesson][:room]), grade: params[:lesson][:grade], room: params[:lesson][:room])

      @subject.classrooms << @classroom unless @subject.classrooms.exists?(@classroom.id)

      @lesson = @classroom.lessons.new(lesson_params)
      @lesson.end_time = @lesson.start_time + 1.hour

    else # params[:lesson][:period] == "Repeat weekly"

      # 時間在資料庫的時區是 +0
      @subject = @user.subjects.find_or_initialize_by(name: params[:lesson][:name])

      # has_and_belongs_to_many
      #@classroom = @subject.classrooms.find_or_initialize_by(name: (params[:lesson][:grade] + params[:lesson][:room]), grade: params[:lesson][:grade], room: params[:lesson][:room])
      @classroom = Classroom.find_or_initialize_by(name: (params[:lesson][:grade] + params[:lesson][:room]), grade: params[:lesson][:grade], room: params[:lesson][:room])

      @subject.classrooms << @classroom unless @subject.classrooms.exists?(@classroom.id)

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
        @lesson = @classroom.lessons.new(lesson_params)
        @lesson.start_time = start
        @lesson.end_time = start + 1.hour
        @lesson.save
        start += 1.week
        i += 1
        break if start > semester.end
      end

    end

    if @lesson.save

      # has_and_belongs_to_many
      @subject = @user.subjects.find_or_create_by(name: params[:lesson][:name])
      @subject.classrooms << @classroom unless @subject.classrooms.exists?(@classroom.id)

      flash[:notice] = "行事曆已增添一筆資料"
      redirect_to user_lessons_path
    else
      flash.now[:alert] = "資料未能在行事曆上新增成功"
      render :new
    end
  end

  def edit
    #lesson = Lesson.find_by_id(params[:id])
    # 不用路由 params 也可將 id 傳入，但括號內不可使用"實例變數"

    # has_and_belongs_to_many
    # 編輯 lesson 不需要給 subject
    #classroom = Classroom.find_by_id(lesson.classroom_id)
    #@subject = Subject.find_by_id(classroom.subject_id)
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
      flash[:notice] = "行事曆已更新一筆資料"
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
      flash[:alert] = "行事曆一筆資料已成功刪除"
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

      # has_and_belongs_to_many
      # classroom_ids = Classroom.where(subject_id: subject_ids).pluck(:id)
      classroom_ids = Classroom.joins("join classrooms_subjects on classrooms.id = classrooms_subjects.classroom_id").where(["classrooms_subjects.subject_id = ?", subject_ids]).pluck(:id)

      # classroom_id 欄位，輸入 id array，輸出 lessons 的 ActiveRecord，不需要用 id 各別宣告再收集起來。
      @lessons = Lesson.where(classroom_id: classroom_ids, event_type: "lesson")
    end

    # 刪除整學期的課程，待利用
    def set_subject_of_lesson
    lesson = Lesson.find_by_id(params[:id])
    # 注意：不用路由 params 也可將 id 傳入，但括號內不可使用"實例變數"。此方法可避免巢狀路由過於複雜。

    # has_and_belongs_to_many
    #classroom = Classroom.find_by_id(lesson.classroom_id)
    #@subject = Subject.find_by_id(classroom.subject_id)
    # 這個關聯要在 @subject name 唯一性，且 @subject 及其下的 @lessons 的名稱需同步 CRUD 才行！

    #@subject = Subject.where(name: lesson.name)
    # 不知為什麼，這個 query 到的實例變數，無法使用 classrooms 關聯方法
    # only for lessons#show 使用

    classroom_id = Classroom.find_by_id(lesson.classroom_id).id
    subjects = Subject.joins("join classrooms_subjects on subjects.id = classrooms_subjects.subject_id").where(["classrooms_subjects.classroom_id = ?", classroom_id])
    @subject = subjects.where(name: lesson.name)
    end

    def set_user
      @user = User.find_by_id(params[:user_id])
    end

    def set_author
      @user = current_user
    end

    def lesson_params
      params.require(:lesson).permit(:name, :start_time,'start_time(1i)', 'start_time(2i)', 'start_time(3i)', 'start_time(4i)', 'start_time(5i)', 'end_time(1i)', 'end_time(2i)', 'end_time(3i)', 'end_time(4i)', 'end_time(5i)', :period, :frequency, :commit_button, :event_type, :grade, :room)
    end

end