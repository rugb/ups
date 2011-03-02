class ConfController < ApplicationController
  include ConfHelper

  def index
  end
  
  def update
    Conf.default_language = Language.find_by_any(params[:default_language])
    Conf.default_page = Page.find(params[:default_page])
    Conf.web_name = params[:web_name]

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
  
end
