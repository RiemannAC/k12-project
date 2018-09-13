class CalendarController < ApplicationController
  before_action :authenticate_user!
  def show
    @date = params[:date] ? Date.parse(params[:date]) : Date.today
    @plans = Plan.order(created_at: :desc)
    @materials =Material.order(created_at: :desc)
    @topics = Topic.order(created_at: :desc)
    @events = Event.all
  end

end