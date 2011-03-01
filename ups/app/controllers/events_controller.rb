require 'pp'
class EventsController < ApplicationController

  #filter_access_to :all

  def calendar
    @title = "Calendar"
  end
  
  def new
  end

  def create
  end

  def edit
  end

  def update
    @event = Event.find params[:id]

    if @event.update_attributes params[:event]
      flash[:success] = "vote succesful"
      redirect_to @event
    else
      
    end
  end

  def destroy
  end

  def user_vote_destroy

  end

  def index
    @events = Event.all
  end

  def show
    @event = Event.find params[:id]

    @title = @event.name

    @user_vote = @event.user_votes.find_or_initialize_by_user_id @current_user.id
    if @user_vote.new_record?
      @event.timeslots.each do |timeslot|
        timeslot.votes.build(:user_vote_id => @user_vote.id)
      end
      @user_vote.save
    end
  end

end
