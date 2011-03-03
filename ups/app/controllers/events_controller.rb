require 'pp'
class EventsController < ApplicationController

  include GoogleHelper
  
  before_filter :load_event, :except => [ :new, :create, :calendar, :index, :user_vote_destroy ]
  before_filter :load_user_vote, :only => :user_vote_destroy #, :model => :UserVote, :attribute_check => true

  # todo
  # check for edit,update attribute
  filter_access_to :edit, :update, :attribute_check => true
  filter_access_to :user_vote_destroy, :model => UserVote, :attribute_check => true
  filter_access_to :all

  def calendar
    @title = "Calendar"
  end
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event].merge(:user_id => @current_user.id))

    if @event.save
      flash[:success] = "vote created"
      redirect_to edit_event_path @event
    else
      flash.now[:error] = "vote not created"
      render 'new'
    end
  end

  def edit
    #loading in before_filter
  end

  def update
    if @event.update_attributes(params[:event])
      flash[:success] = "vote updated"
      redirect_to edit_event_path @event
    else
      flash.now[:error] = "vote update failed"
      render 'edit'
    end
  end

  def new_timeslot
    @event.timeslots.build(:start_at => DateTime.now, :end_at => DateTime.now.advance(:hours => 1)).save

    redirect_to edit_event_path @event
  end

  def finish
    #loading in before_filter
  end

  def finished
    if @event.update_attributes(params[:event])
      @timeslots=[]
      @event.timeslots.each do |timeslot|
        @timeslots << timeslot if timeslot.choosen?
      end

      @event.finished = true
      @event.save!

      if @timeslots.empty?
        flash[:notice] = "no event created"
      else
        count=0
        google = google_auth
        @timeslots.each do |timeslot|
          gevent = {
            :title => @event.name,
            :content => @event.description,
            :where => @event.location,
            :start_time => timeslot.start_at.strftime("%Y-%m-%dT%H:%M:%S"),
            :end_time => timeslot.end_at.strftime("%Y-%m-%dT%H:%M:%S")
          }
          created_event_on_google = google_add_event(google, gevent)
          if created_event_on_google[:saved]
            timeslot.gevent_id = created_event_on_google[:event].id
            timeslot.save
            count += 1
          end
        end

        if count > 0
          flash[:success] = view_context.pluralize(count, "event") + " (of #{@timeslots.count}) created"
        else
          flash[:error] = "no events created"
        end
      end
      redirect_to calendar_path
    else
      flash.now[:error] = "error"
      render 'finish'
    end
  end

  def reopen
    @event.finished = false

    google = google_auth
    @event.timeslots.each do |timeslot|
      if (timeslot.gevent_id.present? && gevent = google_find_event(google, timeslot.gevent_id))
        gevent.delete unless gevent.status == :canceled
      end
      timeslot.gevent_id = nil
      timeslot.save
    end
    
    if @event.save
      flash[:success] = "event reopened"
      redirect_to edit_event_path @event
    else
      flash[:error] = "cannot reopened event"
      redirect_to events_path
    end
  end

  def vote
    if @event.update_attributes params[:event]
      flash[:success] = "vote succesful"
      redirect_to @event
    else
      p @event.errors
    end
  end

  def destroy
    @event.destroy

    redirect_to events_path
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
    if @user_vote.nil? && !@event.finished?
      @user_vote = @event.user_votes.build(:user_id => @current_user.id)
      @event.timeslots.each do |timeslot|
        @user_vote.votes.build(:timeslot_id => timeslot.id)
      end
    end

    @vote_button = !@event.finished? && @user_vote.new_record?
    @finish_button = @current_user == @event.user
    
    @button_div =  @vote_button || @finish_button
  end

  private
    def load_event
      @event = Event.find params[:id]
    end

    def load_user_vote
      @user_vote = UserVote.find params[:user_vote_id]
    end

end
