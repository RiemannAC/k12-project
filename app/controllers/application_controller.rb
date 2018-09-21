class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :call_methods_for_sidebar
  

  private

  def call_methods_for_sidebar
    @subject_tags = SubjectTag.order(name: :desc)
    @user = User.find_by(id: params[:user_id])
    @materials = @user.materials.order(created_at: :desc)
    @materials_count = @user.materials.count
    @plans = @user.plans.order(created_at: :desc)
    @plans_count = @user.plans.count
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
 