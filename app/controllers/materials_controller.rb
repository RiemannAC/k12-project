class MaterialsController < ApplicationController

  def show
    @material = Material.find(params[:id])
    @subject_tags = SubjectTag.order(created_at: :desc)
  end

  def new
    @subjects = SubjectTag.order(created_at: :desc)
    @subject_tags = SubjectTag.order(created_at: :desc)
  end
end
