
require 'openid'                    # Einbinden der benötigten Bibliotheken aus den Gems
require 'openid/store/filesystem'   # Store fürs Speichern der OpenID-Transaktionsdaten
require 'openid/consumer/discovery' # Yadis Discovery Funktionalitäten
require 'openid/extensions/sreg'    # Simple Registration Funktionalitäten
require 'openid/extensions/ax'      # Attribute Exchange Funktionalitäten


class SessionController < ApplicationController
  filter_access_to :login, :show, :start, :logout

  skip_before_filter :verify_authenticity_token

  def login
    @fb3_openid = 'https://openid.tzi.de/'
  end
  

  def start    
    open_id_identifier = params[:openid_identifier] if params[:openid_identifier].present?
    open_id_identifier = params[:openid_fb3][:value] if params[:openid_fb3].present?
    
    if !using_open_id? open_id_identifier
      flash[:error] = "OpenID should not be empty"
      redirect_to :action => :login
      return
    end
    
    open_id_authentication open_id_identifier
  end
  
  def logout
    sign_out
    
    flash[:success] = "You have been logged out."
    redirect_back_or session_login_path
  end
  
  def show
  end
  
  def successful_login
    sign_in @current_user

    set_current_user
    
    redirect_back_or root_path, :flash => { :success => "You're logged in." }
  end
  
  def failed_login(error)
     flash[:error] = error
     redirect_to session_login_path
  end
  
  def permission_denied
    if has_role? :guest
      store_location
      redirect_to session_login_path, :flash => { :error => "Please sign in to access this page." }
    else
      http_404
    end
  end
  
  private

  def open_id_authentication(openid_url)
    authenticate_with_open_id(openid_url, :required => [ :nickname, :email ], :optional => :fullname) do |result, identity_url, registration|      
      if result.successful? && @current_user = User.find_or_initialize_by_openid(identity_url)
        if @current_user.new_record?
	  role = User.all.count == 1 ? Role.find_by_int_name(:admin) : Role.find_by_int_name(:user)
	  @current_user.role = role
        end
        @current_user.name = registration['nickname']
        @current_user.email = registration['email']
        @current_user.fullname = registration['fullname'] if registration['fullname'].present?

        @current_user.save
	
        successful_login
      else
        failed_login(result.message || "Sorry, no user by that identity URL exists (#{identity_url})")
      end
    end
  end
end
