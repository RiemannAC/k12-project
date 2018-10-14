class SubjectsController < ApplicationController
  def index
  end
 
  private

  def subject_params
    params.require(:subject).permit(:name, :classroom, :grade, :students, :start_time, :end_time,:user_id)    
  end
end