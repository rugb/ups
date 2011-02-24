
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
    
    authenticate_with_open_id(open_id_identifier, :required => [:nickname, :email]) do |result, identity_url, registration|
      if result.successful?
        @user = User.find_or_initialize_by_identity_url(identity_url)
        if @user.new_record?
          @user.login = registration['nickname']
          @user.email = registration['email']
          @user.save(false)
        end
        self.current_user = @user
        successful_login
      else
        failed_login result.message
      end
    end

  end
  
  def loggin_in?
    true
  end
  
  def successful_login
    flash.now[:success] = "logged in"
  end
  
  def failed_login(error)
    flash.now[:error] = error
  end
  
  private
  
  # Die Daten der OpenID-Transaktionen werden in diesem Fall im Dateisystem abgelegt.
  # Sollte dies nicht erwünscht sein, kann auch ein anderer Store-Mechanismus angegeben
  # werden - näheres dazu findet sich in der Dokumentation des ruby-openid Gems unter:
  # http://www.openidenabled.com/ruby-openid/
  def openid_consumer
    store = OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid")
    @openid_consumer ||= OpenID::Consumer.new(session, store)
  end
  
  # Die URL des Identity Providers - in diesem Fall die URL
  # des OpenID-Servers des Fachbereich 3 der Uni Bremen
  def identity_provider
    'https://openid.tzi.de/'
  end
end
