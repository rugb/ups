class EventsController < ApplicationController

  #filter_access_to :all

  def calendar
  end
  
  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])

    @title = @event.name
  end

end
