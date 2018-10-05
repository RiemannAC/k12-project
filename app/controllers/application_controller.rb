class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :call_methods_on_sidebar
  
  skip_before_action :verify_authenticity_token

  private

  def call_methods_on_sidebar
    if signed_in?
      @user = current_user
      @subjects = @user.subjects.all
      @materials = @user.materials.all
      @plans = @user.plans.all
      @subject_tags = SubjectTag.order(name: :desc)
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
 