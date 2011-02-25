
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
  

  def start    
    open_id_identifier = params[:openid_identifier] if params[:openid_identifier].present?
    open_id_identifier = params[:openid_fb3][:value] if params[:openid_fb3].present?
    

    #if open_id_identifier.nil?
    #  redirect_to session_login_path
    #  return
    #end
    
    open_id_authentication open_id_identifier
  end
  
  def logout
    sign_out
    
    flash[:success] = "You have been logged out."
    redirect_to root_path
  end
  
  def show
    @current_user = current_user
  end
  
  def successful_login
    sign_in @current_user

    set_current_user
    
    flash[:success] = "logged in"
    redirect_to root_path
  end
  
  def failed_login(error)
     flash[:error] = error
     redirect_to session_login_path
  end
  
  private

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
