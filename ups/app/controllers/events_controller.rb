require 'pp'
class EventsController < ApplicationController

  before_filter :load_event, :except => [ :calendar, :index, :user_vote_destroy ]
  before_filter :load_user_vote, :only => :user_vote_destroy, :model => :UserVote, :attribute_check => true
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
    if @event.update_attributes params[:event]
      flash[:success] = "vote succesful"
      redirect_to @event
    else
      p @event.errors
    end
  end

  def destroy
  end

  def user_vote_destroy
    @user_vote.destroy

    redirect_to @user_vote.event
  end

  def index
    @events = Event.all
  end

  def show
    @title = @event.name

    @user_vote = @event.user_votes.find_by_user_id @current_user.id
    if @user_vote.nil?
      @user_vote = @event.user_votes.build(:user_id => @current_user.id)
      @event.timeslots.each do |timeslot|
        @user_vote.votes.build(:timeslot_id => timeslot.id)
      end
    end
  end

  private
    def load_event
      @event = Event.find params[:id]
    end

    def load_user_vote
      @user_vote = UserVote.find params[:user_vote_id]
    end

end
