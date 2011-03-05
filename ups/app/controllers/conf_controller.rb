class ConfController < ApplicationController
  include ConfHelper

  def index
  end

  def update
    Conf.default_language = Language.find_by_any(params[:default_language])
    Conf.default_page = Page.find(params[:default_page])
    Conf.web_name = params[:web_name]
    Conf.calendar = params[:calendar_url]
    Conf.github_user = params[:github_user]

    Conf.google_account_name = params[:google_account_name].strip
    Conf.google_account_password = params[:google_account_password].strip

    Conf.twitter_consumer_key = params[:consumer_key].strip
    Conf.twitter_consumer_secret = params[:consumer_secret].strip
    Conf.twitter_oauth_token = params[:oauth_token].strip
    Conf.twitter_oauth_secret = params[:oauth_secret].strip

    flash.now[:success] = "settings saved."

    @selected_tab = params[:tab][:selected].gsub(/^[^#]*#/, "") if params[:tab][:selected].present?

    render :action => :index
  end

  def check_twitter
    if twitter_check
      flash.now[:success] = "twitter works."
    else
      flash.now[:error] = "twitter fails. check your keys and secrets."
    end

    render :action => :index
  end


  def check_google
    if google_check
      flash.now[:success] = "google works."
    else
      flash.now[:error] = "google fails."
    end

    render :action => :index
  end

  def create_google_calendar
    google = google_auth

    cal = GCal4Ruby::Calendar.new(google, :title => Conf.web_name, :timezone => "Europe/Berlin")

    if cal.save
      Conf.google_calendar_id = cal.id
      flash[:success] = "calendar created"
    else
      flash[:error] = "calendar not created"
    end

    redirect_to :action => :index
  end

  def pull_github
    begin
      user = GitHub.user(Conf.github_user)
      if user.repositories.any?
        project_page = Page.projects

        user.repositories.each do |repo|
          page = Page.project_by_repo repo
          cache_html! page
        end
      end

      flash.now[:success] = "github projects pulled"
    rescue
      flash.now[:error] = "github pull failed."
    end

    render :action => :index
  end
end
