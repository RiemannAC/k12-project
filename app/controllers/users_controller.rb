class UsersController < ApplicationController

  def show
    def edit
      unless @user==current_user
        redirect_to user_path(@user)
      end
    end
  end

end
