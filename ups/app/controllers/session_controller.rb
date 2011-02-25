
require 'openid'                    # Einbinden der benötigten Bibliotheken aus den Gems
require 'openid/store/filesystem'   # Store fürs Speichern der OpenID-Transaktionsdaten
require 'openid/consumer/discovery' # Yadis Discovery Funktionalitäten
require 'openid/extensions/sreg'    # Simple Registration Funktionalitäten
require 'openid/extensions/ax'      # Attribute Exchange Funktionalitäten


class SessionController < ApplicationController
  filter_access_to :login, :show

  skip_before_filter :verify_authenticity_token

  def login
    @fb3_openid = 'https://openid.tzi.de/'
  end
  
  # Die start-Action initialisiert die Anfrage, dabei werden auch die angeforderten Attribute 
  # angegeben, welche in diesem Fall mittels Attribute Exchange angefordert werden. 
  def start    
    open_id_identifier = params[:openid_identifier] if params[:openid_identifier].present?
    open_id_identifier = params[:openid_fb3][:value] if params[:openid_fb3].present?
    
    open_id_authentication(open_id_identifier)
  end
  
  def logout
    sign_out
    
#     self.current_user.forget_me if logged_in?
#     cookies.delete :auth_token
#     reset_session
     flash[:notice] = "You have been logged out."
     redirect_back_or(root_path)
  end
  
  def show
    @current_user = current_user
  end
  
  def successful_login
    sign_in(@current_user)
    set_current_user
    
    flash[:success] = "logged in"
    redirect_to root_path
  end
  
  def failed_login(error)
     flash[:error] = error
     redirect_to session_login_path
  end
  
  private
  
  # Die Daten der OpenID-Transaktionen werden in diesem Fall im Dateisystem abgelegt.
  # Sollte dies nicht erwünscht sein, kann auch ein anderer Store-Mechanismus angegeben
  # werden - näheres dazu findet sich in der Dokumentation des ruby-openid Gems unter:
  # http://www.openidenabled.com/ruby-openid/
  def consumer
    dir = Pathname.new(RAILS_ROOT).join('db').join('cstore')
    store = OpenID::Store::Filesystem.new(dir)
    @openid_consumer ||= OpenID::Consumer.new(session, @store)
  end
  
  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [ :nickname, :email ], :optional => :fullname) do |result, identity_url, registration|      
      if result.successful? && @current_user = User.find_or_initialize_by_openid(identity_url)
        if @current_user.new_record?
	  @current_user.role = Role.find_by_int_name(:user)
          @current_user.name = registration['nickname']
          @current_user.email = registration['email']
	  @current_user.fullname = registration['fullname']
          @current_user.save(false)
        end
	
        successful_login
      else
        failed_login(result.message || "Sorry, no user by that identity URL exists (#{identity_url})")
      end
    end
  end

end
