class TeachingfilesController < ApplicationController
  
  def create
    @user = User.find(params[:user_id])
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
    @teachingfile.save
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
      redirect_to user_plan_path(@user,@plan)
    end
  end

  def edit
    @subject_tags = SubjectTag.order(created_at: :desc)
    @user = User.find(params[:user_id])
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
    @user = User.find(params[:user_id])
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
    @teachingfile = Teachingfile.find(params[:id])
    @topic = Topic.find_by(params[:topic_id])
    # 呼叫其他 model 要用 find_by 才找得到 id?
    @topic.addfiles.create(teachingfile: @teachingfile)
    redirect_back fallback_location: root_path
  end

  def removefile
    @teachingfile = Teachingfile.find(params[:id])
    @topic = Topic.find_by(params[:topic_id])
    addfiles = Addfile.where(teachingfile: @teachingfile, topic: @topic)
    addfiles.destroy_all
    redirect_back fallback_location: root_path
  end



  private

  def teachingfile_params
    params.require(:teachingfile).permit(:name,:material_id,:plan_id, :user_id, {attachments: []})
  end
end
