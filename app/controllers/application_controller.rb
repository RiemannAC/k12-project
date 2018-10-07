class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  #before_action :call_methods_on_navbar
  

  private

  def call_methods_on_navbar
    if signed_in?
      @user = current_user

      # _to_do_list
      @day = Date.today
      @todos = Lesson.where(event_type: "todo")
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def authenticate_author
    unless @user = current_user
      flach[:alert] = "Not Allow!"
      redirect_to user_lessons_path
    end
  end

end
 