class SubjectsController < ApplicationController

  def index
    
  end

  def new
    @subject = @user.subjects.new
  end



  private

  def subject_params
    params.require(:subject).permit(:name, :classroom, :grade)    
  end
end