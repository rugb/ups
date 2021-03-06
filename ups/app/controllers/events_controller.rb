require 'pp'
class EventsController < ApplicationController

  include GoogleHelper
  include ConfHelper

  before_filter :load_event, :except => [ :new, :create, :calendar, :index, :user_vote_destroy, :new_absence, :create_absence ]
  before_filter :load_user_vote, :only => :user_vote_destroy

  filter_access_to :edit, :update, :attribute_check => true
  filter_access_to :user_vote_destroy, :model => UserVote, :attribute_check => true
  filter_access_to :all

  def calendar
    @title = "Calendar"
  end

  def new_absence
    @title = "new absence"

    @timeslot = Timeslot.new(:user_id => @current_user.id)
  end

  def create_absence
    # convert string to int (month, ... )
    time = params[:time].each_with_object({}) { |(k,v),h| h[k] = v.to_i }

    start_at = DateTime.civil_from_format("local", time["start_at(1i)"], time["start_at(2i)"], time["start_at(3i)"], 0, 0)
    end_at = DateTime.civil_from_format("local", time["end_at(1i)"], time["end_at(2i)"], time["end_at(3i)"], 0, 0)

    gevent = {
      :title => "absence: #{@current_user.name}",
      :content => params[:description],
      :start_time => start_at.strftime("%Y-%m-%dT%H:%M:%S"),
      :end_time => end_at.strftime("%Y-%m-%dT%H:%M:%S"),
      :all_day => true
    }

    google = google_auth
    created_event_on_google = google_add_event(google, gevent)
    if created_event_on_google[:saved]
      flash[:success] = "absence created"
    else
      flash[:error] = "error"
    end

    redirect_to :action => :calendar
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

      @event.update_attribute :finished, true

      if google_check
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
              timeslot.update_attribute :gevent_id, created_event_on_google[:event].id
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
        flash[:notice] = "event finished"
        redirect_to events_path
      end
    else
      flash.now[:error] = "error"
      render 'finish'
    end
  end

  def reopen
    @event.finished = false

    google = google_auth
    @event.timeslots.each do |timeslot|
      if (timeslot.gevent_id? && gevent = google_find_event(google, timeslot.gevent_id))
        gevent.delete unless gevent.status == :canceled
      end
      timeslot.update_attribute :gevent_id, nil
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
