
require 'openid'                    # Einbinden der benötigten Bibliotheken aus den Gems
require 'openid/store/filesystem'   # Store fürs Speichern der OpenID-Transaktionsdaten
require 'openid/consumer/discovery' # Yadis Discovery Funktionalitäten
require 'openid/extensions/sreg'    # Simple Registration Funktionalitäten
require 'openid/extensions/ax'      # Attribute Exchange Funktionalitäten


class SessionController < ApplicationController
  
  skip_before_filter :verify_authenticity_token

  def login
    @fb3_openid = 'https://openid.tzi.de/'
  end
  
  # Die start-Action initialisiert die Anfrage, dabei werden auch die angeforderten Attribute 
  # angegeben, welche in diesem Fall mittels Attribute Exchange angefordert werden. 
  def start    
    open_id_identifier = params[:openid_identifier] if params[:openid_identifier].present?
    open_id_identifier = params[:openid_fb3][:value] if params[:openid_fb3].present?
    
    openid_request = consumer.begin(open_id_identifier)
    
    trust_root = root_url
    return_to = url_for :action => :complete, :only_path => false
    realm = url_for :action => :login, :id => nil, :only_path => false
    
    if openid_request.send_redirect?(realm, return_to)
      redirect_to openid_request.redirect_url(realm, return_to)
    else
      render :text => openid_request.html_markup(realm, return_to)
    end
  end
  
  def complete
    openid_response = consumer.complete(params, url_for({}))
    
    case openid_response.status
    when OpenID::Consumer::SUCCESS
      id_url = openid_response.identity_url
      
      @user = User.find_or_initialize_by_identity_url(id_url)
      
    #  if @user.
    when OpenID::Consumer::SETUP_NEEDED
	redirect_to openid_response.setup_url
	return
	
      when OpenID::Consumer::FAILURE
	flash[:error] = "Could not login"
	redirect_back_or(:controller => :session, :action => :login)
      end
  end
  
  def loggin_in?
    true
  end
  
  def successful_login
    flash.now[:success] = "logged in"
  end
  
  def failed_login(error)
#     flash.now[:error] = error
  end
  
  private
  
  # Die Daten der OpenID-Transaktionen werden in diesem Fall im Dateisystem abgelegt.
  # Sollte dies nicht erwünscht sein, kann auch ein anderer Store-Mechanismus angegeben
  # werden - näheres dazu findet sich in der Dokumentation des ruby-openid Gems unter:
  # http://www.openidenabled.com/ruby-openid/
  def consumer
    dir = Pathname.new(RAILS_ROOT).join('db').join('cstore')
    @store ||= OpenID::Store::Filesystem.new(dir)
    @openid_consumer ||= OpenID::Consumer.new(session, @store)
  end
  
  # Die URL des Identity Providers - in diesem Fall die URL
  # des OpenID-Servers des Fachbereich 3 der Uni Bremen
  def identity_provider
    'https://openid.tzi.de/'
  end
end
