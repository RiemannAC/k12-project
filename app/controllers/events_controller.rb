class EventsController < ApplicationController

  before_action :set_user, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_todo, only: [:edit, :update, :destroy]

  # GET /events/new
  def new
    @todo = @user.events.new
  end 

  # POST /events
  # POST /events.json
  def create
    @todo = @user.events.new(event_params)
    if @todo.save
      flash[:notice] = "已新增待辦事項"
      redirect_to root_path
    else
      flash.now[:alert] = "@todo.errors.full_messages.to_sentence"
      render :new
    end

    # create ajax 用連結指向 model 頁面，不用下面的寫法

    # respond_to do |format|
    #   if @event.save
    #     format.html { redirect_to user_lessons_url, notice: '成功新增一個待辦事項' }
    #     format.json { render :show, status: :created, location: user_lessons_url }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @event.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    # 一般版
    # if @todo.update(event_params)
    #   @todo.save
    #   flash[:notice] = "已更新此待辦事項"
    #   redirect_to root_path
    # else
    #   flash.now[:alert] = "@todo.errors.full_messages.to_sentence"
    #   render :edit
    # end

    # ajax 版
    @todo.save
    respond_to do |format|
       if @todo.update(event_params)
         format.html { redirect_to user_lessons_url, notice: '成功更新此待辦事項' }
         format.json { render :show, status: :ok, location: user_lessons_url }
         #format.js
       else
         format.html { redirect_to root_path }
         flash[:alert]="更新失敗，待辦事項的名稱不可空白"
       end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    # 一般版
    # if @todo.destroy
    #   flash[:alert] = "已成功刪除此待辦事項"
    #   redirect_to root_path
    # else
    #   flash[:alert] = "@todo.errors.full_messages.to_sentence"
    #   redirect_to root_path
    # end

    # ajax 版
    @todo.destroy
    respond_to do |format|
      format.js   
    end
  end

  private

    # 個人隱私關係，使用者只看得到自己的待辦事項
    def set_user
      @user = current_user
    end

    def set_todo
      @todo = @user.events.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start_time, :end_time,:user_id)
    end
end
