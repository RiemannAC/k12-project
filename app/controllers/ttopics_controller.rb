class TtopicsController < ApplicationController
  before_action :set_ttopic, only: [:show, :edit, :update, :destroy]

  # GET /ttopics
  # GET /ttopics.json
  def index
    @ttopics = Ttopic.all
  end

  # GET /ttopics/1
  # GET /ttopics/1.json
  def show
  end

  # GET /ttopics/new
  def new
    @ttopic = Ttopic.new
  end

  # GET /ttopics/1/edit
  def edit
  end

  # POST /ttopics
  # POST /ttopics.json
  def create
    @user = current_user
    @subject = @user.subjects.find(params[:subject_id])
    @ttopic = @subject.ttopics.new(ttopic_params)

    respond_to do |format|
      if @ttopic.save
        format.html { redirect_to user_subject_path(@user, @subject), notice: '成功新增教學主題' }
        format.json { render :show, status: :created, location: @ttopic }
      else
        format.html { render :new }
        format.json { render json: @ttopic.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ttopics/1
  # PATCH/PUT /ttopics/1.json
  def update
    respond_to do |format|
      if @ttopic.update(ttopic_params)
        format.html { redirect_to @ttopic, notice: 'Ttopic was successfully updated.' }
        format.json { render :show, status: :ok, location: @ttopic }
      else
        format.html { render :edit }
        format.json { render json: @ttopic.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ttopics/1
  # DELETE /ttopics/1.json
  def destroy
    @ttopic.destroy
    respond_to do |format|
      format.html { redirect_to ttopics_url, notice: 'Ttopic was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ttopic
      @ttopic = Ttopic.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ttopic_params
      params.require(:ttopic).permit(:name, :start_time, :end_time, :subject_id, :feedback)
    end
end
