class PlansController < ApplicationController
  def index
    @subject_tags = SubjectTag.order(created_at: :desc)
  end
end
