class AttachmentsController < ApplicationController
  before_action :set_teachingfile

  def destroy
    @attachments = @teachingfile.attachments
    remove_attachment_at_index(params[:id].to_i)
    flash[:error] = "Failed deleting attachment" unless @teachingfile.save
    redirect_back fallback_location: root_path
  end

  private

  def remove_attachment_at_index(index)
    remain_files = @teachingfile.attachments
    deleted_file = remain_files.delete_at(index)
    deleted_file.try(:remove!)
    @teachingfile.attachments = remain_files
  end

  def set_teachingfile
    if params[:material_id]
      # if it is a material id, set instance of post id as @parent
      @parent = Material.find(params[:material_id])
    elsif params[:plan_id]
      # if it is a plan id, set instance of topic id as @parent
      @parent = Plan.find(params[:plan_id])
    end

    @teachingfile = @parent.teachingfiles.find(params[:teachingfile_id])
  end

  def attachments_params
    params.require(:teachingfile).permit({attachments: []})
  end
end
