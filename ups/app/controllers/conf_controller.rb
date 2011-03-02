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

  def pull_github
    begin
      user = GitHub::API.user(Conf.github_user)
      p "=======================", user.repositories

      flash.now[:success] = "github projects pulled"
    rescue
      flash.now[:error] = "github pull failed."
    end

    render :action => :index
  end
  
end
