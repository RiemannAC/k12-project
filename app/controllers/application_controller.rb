class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :call_methods_on_navbar
  

  private

  def call_methods_on_navbar
    if signed_in?
      @lessons = Lesson.all
      @lesson = Lesson.find_by_id(params[:lesson_id])
    # 注意：不用路由 params 也可將 id 傳入，但括號內不可使用"實例變數"。此方法可避免巢狀路由過於複雜。
      if params[:lesson_id]
      topic = Topic.find_by_id(lesson.topic_id)
      @subjects = topic.subjects.all
      end
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
 