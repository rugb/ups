class ApplicationController < ActionController::Base
  include SessionHelper
  
  protect_from_forgery
  
  #rescue_from ActiveRecord::RecordNotFound, :with => :http_404
  
  helper_method :select_by_language_id, :current_user
  
  before_filter :current_user
  before_filter :current_page
  
  helper_method :select_by_language_id
  
  def http_404
    @title = "404 - page not found"
    render 'errors/404', :status => 404
  end
  
  def http_500
    @title = "500 - internal server error"
    render 'errors/500', :status => 500
  end
  
  def select_by_language_id(elements)
    wanted_languages.each { |language|
      elements.each { |element|
        return element if element.language_id == language.id  
      }
    }
    
    elements.first
  end
  
  # returns a prioritised array of Languages wich should be used to render the page content
  def wanted_languages
    wanted_languages = []
    
    # explicit selected in url
    wanted_languages << Language.find_by_short(params[:language_short])
    
    # session/user
    #wanted_languages << Language.find_by_short(cookies.signed[:user_language]) if cookies.signed[:user_language].present?
    wanted_languages << Language.find_by_short(get_session_language) if get_session_language.present?
    
    # wanted by browser
    wanted_languages |= accepted_languages.map do |lang|
      Language.find_by_short(lang)
    end
    
    # default language
    wanted_languages << Conf.default_language
    
    # cleanup
    wanted_languages.delete_if{ |lang| lang.nil? }
  end
  
  # by http://mashing-it-up.blogspot.com/2008/10/parsing-accept-language-in-rails.html
  # Returns the languages accepted by the visitors, sorted by quality
  # (order of preference).
  def accepted_languages
    # no language accepted
    return [] if request.env["HTTP_ACCEPT_LANGUAGE"].nil?
    
    # parse Accept-Language
    accepted = request.env["HTTP_ACCEPT_LANGUAGE"].split(",")
    accepted = accepted.map { |l| l.strip.split(";") }
    accepted = accepted.map { |l|
      if (l.size == 2)
        # quality present
        [ l[0].split("-")[0].downcase, l[1].sub(/^q=/, "").to_f ]
      else
        # no quality specified =&gt; quality == 1
        [ l[0].split("-")[0].downcase, 1.0 ]
      end
    }
    
    # sort by quality
    accepted.sort { |l1, l2| l2[1] - l1[1] }
    
    # reduce to short
    accepted.map do |a|
      a[0]
    end
  end
  
  protected
  
  # neccessary for declarative_authorization model permissions
  def set_current_user
    # current_user should be defined somewhere as the logged in used
    Authorization.current_user = @current_user
  end
  
  def current_page
    page = Page.find(:first, :conditions => {:forced_url => request.path})
    @page = page if page.present? && page.visible?
  end  
end
