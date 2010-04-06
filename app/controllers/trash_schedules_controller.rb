class TrashSchedulesController < ApplicationController

  respond_to :html, :json

  before_filter :load_trash_schedule, :only => :show

  caches_page :about
  caches_action :index, :if => lambda { |c| c.params[:q].blank? }

  def index
    if !params[:q].blank?
       @trash_schedules = TrashSchedule.search(params[:q])
      if @trash_schedules.size == 1
        redirect_to(trash_schedule_path(@trash_schedules.first))
      else
        respond_with(@trash_schedules)
      end
    end
  end

  def show
    respond_with(@trash_schedule)
  end
  
  def about
    # noop
  end

  protected

  def load_trash_schedule
    @trash_schedule = TrashSchedule.find(params[:id])
  end
end
