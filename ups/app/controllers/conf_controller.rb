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
    end

    render :action => :index
  end
      
  def pull_github
    begin
      user = GitHub.user(Conf.github_user)
      if user.repositories.any?
        project_page = Page.find_or_initialize_by_int_title :projects
        if project_page.page_contents.empty?
          project_page.parent = nil
          project_page.int_title = :projects
          project_page.enabled = false
          project_page.page_type = :page
          project_page.position = 23
          project_page.role = Role.find_by_int_name :guest
          project_page.save!
          project_page.page_contents.build(:language_id => Language.find_by_short("en").id, :title => "Projects").save
          project_page.page_contents.build(:language_id => Language.find_by_short("de").id, :title => "Projekte").save
        end

        user.repositories.each do |repo|
          page = Page.find_or_initialize_by_int_title(repo.name.tr(" ", "_").downcase.tr("^a-z0-9_", ""))
          if page.page_contents.empty?
            page.parent = project_page
            page.enabled = false
            page.page_type = :project
            page.position = 23
            page.role = Role.find_by_int_name :guest
            page.save!
            page.page_contents.build(:language_id => Conf.default_language.id, :title => repo.name, :text => repo.description).save
            cache_html! page
          end
        end
      end

      flash.now[:success] = "github projects pulled"
    rescue
      flash.now[:error] = "github pull failed."
    end

    render :action => :index
  end
end
