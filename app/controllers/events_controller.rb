class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @user = current_user
    @events = @user.events.all
      respond_to do |format|
      format.html { render 'index' }
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @user = current_user
    @event = @user.events.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @user = current_user
    @event = @user.events.new(event_params)
    respond_to do |format|
      if @event.save
        format.html { redirect_to user_lessons_url, notice: '成功新增一個待辦事項' }
        format.json { render :show, status: :created, location: user_lessons_url }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to user_lessons_url, notice: '成功更新此待辦事項' }
        format.json { render :show, status: :ok, location: user_lessons_url }
        #format.js
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
        #format.js
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to user_lessons_url, notice: '成功刪除此待辦事項' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @user = current_user
      @event = @user.events.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:title, :start, :end,:user_id)
    end
end
