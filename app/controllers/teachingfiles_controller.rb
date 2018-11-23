class TeachingfilesController < ApplicationController
  before_action :set_user, only: [:create, :edit, :update, :destroy, :addfile, :removefile]
  before_action :set_file, only: [:addfile, :removefile]

  def create
    # upon clicking on create, determine what param id is passed
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @material= @user.materials.find(params[:material_id])
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
      @plan= @user.plans.find(params[:plan_id])
      @parent = Plan.find(params[:plan_id])
    end

    @teachingfile = @parent.teachingfiles.new(teachingfile_params)
    

    # save teachingfile to database
    if @teachingfile.save
    # direction of save through if and elsif
    # Redirection depends on the comment's parent.
    # .is_a? method determines if it is of a certain class.  Here, is @parent
    # of class Post?  Is @parents is the same parent id passed through params?
      if @parent.is_a?(Material) # template error with this included: (== params[:post_id])
        flash[:notice] = '成功新增教材的檔案'
        redirect_to user_material_path(@user,@material)
      # if not part of the class Post, is it a Topic?  If so, save here and
      # redirect to the topic after save
      elsif @parent.is_a?(Plan)
        flash[:notice] = '成功新增教案的檔案'
        redirect_back fallback_location: root_path
      end
    else
      if @parent.is_a?(Material)
        flash[:alert] = "請確定已輸入檔名或新增附件"
        redirect_to user_material_path(@user, @material)
      elsif @parent.is_a?(Plan)
        flash[:alert] = "請確定已輸入檔名或新增附件"
        redirect_back fallback_location: root_path
      end
    end 
  end

  def edit
    @subject_tags = SubjectTag.order(created_at: :desc)
    # upon clicking on create, determine what param id is passed
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @material= @user.materials.find(params[:material_id])
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
      @plan= @user.plans.find(params[:plan_id])
      @parent = Plan.find(params[:plan_id])
    end
    @teachingfile = @parent.teachingfiles.find(params[:id])
  end

  def update 
    # upon clicking on create, determine what param id is passed
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @material= @user.materials.find(params[:material_id])
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
      @plan= @user.plans.find(params[:plan_id])
      @parent = Plan.find(params[:plan_id])
    end 
   
    @teachingfile = @parent.teachingfiles.find(params[:id])

    if @teachingfile.update(teachingfile_params)
      flash[:notice] = "《#{@teachingfile.name}》成功新增"
      if params[:material_id]
        redirect_to user_material_path(@user,@material)
      elsif params[:plan_id]
        redirect_to user_plan_path(@user,@plan)
      end
    else
      @teachingfile = Teachingfile.all
      flash[:alert] = "檔案名稱不可空白"
      redirect_back fallback_location: root_path
    end
  end
   
  def destroy
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
      @parent = Plan.find(params[:plan_id])
    end
    # @material = Material.find(params[:material_id])
    # material_teachingfiles = @material.teachingfiles.find(params[:id])

    # @plan = Plan.find(params[:plan_id])
    # plan_teachingfiles = @plan.teachingfiles.find(params[:id])
    @teachingfile = @parent.teachingfiles.find(params[:id])
    if @teachingfile.destroy
      flash[:alert] = "成功刪除檔案"
      redirect_back fallback_location: root_path
    else
      flash[:alert] = "檔案刪除失敗"
      redirect_back fallback_location: root_path
    end
  end
 
  def addfile
    #@topic = Topic.find_by(params[:topic_id])
    # 呼叫其他 model 要用 find_by 才找得到 id?
    @teachingfile.addfiles.create!(topic: @topic)
    flash[:notice] = "已將檔案放入「#{@topic.name}」教學單元"
    redirect_back fallback_location: root_path
  end 

  def removefile
    addfile = Addfile.where(teachingfile: @teachingfile, topic: @topic)
    addfile.destroy_all
    flash[:alert] = "檔案已從「#{@topic.name}」教學單元中移除"
    redirect_back fallback_location: root_path
  end

  private

  def set_user
    @user = current_user
  end

  def set_file
    @classroom = @user.classrooms.find(params[:classroom_id])
    @topic = @classroom.topics.find(params[:topic_id])
    @teachingfile = Teachingfile.find(params[:id])
  end

  def teachingfile_params
    params.require(:teachingfile).permit(:name,:material_id,:plan_id, :user_id, {attachments: []})
  end
end
