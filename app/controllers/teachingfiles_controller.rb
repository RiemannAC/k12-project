class TeachingfilesController < ApplicationController
  def create
    # upon clicking on create, determine what param id is passed
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
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
        flash[:notice] = '成功新增教材的檔案 #{@teachingfile.filename}'
        redirect_to material_path(@teachingfile.material)
      # if not part of the class Post, is it a Topic?  If so, save here and
      # redirect to the topic after save
      elsif @parent.is_a?(Plan)
        flash[:notice] = '成功新增教案的檔案 #{@teachingfile.filename}'
        redirect_to plan_path(@teachingfile.plan)
      
      end
    end
  end

  def edit
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
      @parent = Plan.find(params[:plan_id])
    end
    @teachingfile = @parent.teachingfiles.find(params[:id])
  end

  def update 
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
      @parent = Plan.find(params[:plan_id])
    end
    @teachingfile = @parent.teachingfiles.find(params[:id])

    if @teachingfile.update(teachingfile_params)
      flash[:notice] = "teachingfile #{@teachingfile.filename} was successfully updated"
      if params[:material_id]
        redirect_to material_path(@teachingfile.material)
      elsif params[:plan_id]
        redirect_to plan_path(@teachingfile.plan)
      end
    else
      @teachingfile = Teachingfile.all
      flash[:alert] = "filename cannot be blank"
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
      flash[:notice] = "成功刪除檔案"
      redirect_back fallback_location: root_path
    else
      flash[:alert] = "檔案刪除失敗"
      redirect_back fallback_location: root_path
    end
  end

  private

  def teachingfile_params
    params.require(:teachingfile).permit(:filename,:attachment,:material_id,:plan_id)
  end
end


   