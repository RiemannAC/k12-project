class UsersController < ApplicationController

  
  def week_sche
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @user = User.find(params[:id])
  end

  def month_sche
    
  end

end
