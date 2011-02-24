
require 'openid'                    # Einbinden der benötigten Bibliotheken aus den Gems
require 'openid/store/filesystem'   # Store fürs Speichern der OpenID-Transaktionsdaten
require 'openid/consumer/discovery' # Yadis Discovery Funktionalitäten
require 'openid/extensions/sreg'    # Simple Registration Funktionalitäten
require 'openid/extensions/ax'      # Attribute Exchange Funktionalitäten


class SessionController < ApplicationController
  
  skip_before_filter :verify_authenticity_token

  
  #def new
  #end

  #def create
  #end

  def destroy
  end
  
  
  # Die start-Action initialisiert die Anfrage, dabei werden auch die angeforderten Attribute 
  # angegeben, welche in diesem Fall mittels Attribute Exchange angefordert werden. 
  def start
    begin
      # In diesem Fall wird der Identity Provider des Fachbereich 3 direkt angesprochen. Wenn es
      # möglich sein soll, dass der Benutzer einen Identity Provider seiner Wahl angeben kann,
      # dann muss der begin-Methode die vom Benutzer angegebene OpenID-URL übergeben werden.
      oidreq = openid_consumer.begin(identity_provider)
    rescue OpenID::OpenIDError => e
      failed_login("Der OpenID-Server #{identity_provider} konnte nicht kontaktiert werden.<br />#{e}")
      return
    end
    # Anfrage von Benutzerdaten mittels Attribute Exchange. In diesem Fall werden relativ
    # viele Attribute angefragt, es empfiehlt sich, jedoch nur die Daten anzufordern,
    # welche auch für die Anwendung benötigt werden.
    #
    # Erster Parameter bei der Attributanfrage ist der Type Identifier, des gewünschten
    # Attributs. Eine Liste aller verfügbaren Attribute findet sich unter:
    # https://openid.tzi.de/spec/schema
    #
    # Zweiter Parameter ist der Bezeichner des Attributs, welcher dem Benutzer dargestellt wird.
    # Der dritte Parameter ist ein Boolean und kennzeichnet Attribute als erforderlich (true) oder
    # optional (false). Als vierter Parameter kann zusätzlich die Anzahl der Werte für das Attribut
    # angegeben werden - standardmäßig ist dies 1.
    axreq = OpenID::AX::FetchRequest.new
    requested_attrs = [
#      ['http://openid.tzi.de/spec/schema/uid', 'Kennung', true],
#      ['http://openid.tzi.de/spec/schema/mail', 'E-Mail', true],
#      ['http://openid.tzi.de/spec/schema/affiliation', 'Zugehörigkeit', true],
#      ['http://openid.tzi.de/spec/schema/degreeCourse', 'Studiengang', true],
      ['http://openid.tzi.de/spec/schema/givenName', 'Vorname'],
      ['http://openid.tzi.de/spec/schema/surName', 'Nachname'],
      ['http://openid.tzi.de/spec/schema/displayName', 'Voller Name']
#      ['http://openid.tzi.de/spec/schema/principalName', 'Netz-ID'],
#      ['http://openid.tzi.de/spec/schema/telephoneNumber', 'Telefon'],
#      ['http://openid.tzi.de/spec/schema/postalAddress', 'Adresse'],
#      ['http://openid.tzi.de/spec/schema/matriculationNumber', 'Matrikelnummer']]
      ]
    requested_attrs.each { |a| axreq.add(OpenID::AX::AttrInfo.new(a[0], a[1], a[2] || false, a[3] || 1)) }
    oidreq.add_extension(axreq)
    
    # Anfrage von Attributen mittels Simple Registration. SReg sollte nur in Ausnahmefällen 
    # genutzt werden, beispielsweise wenn Daten von Benutzern außerhalb der Uni angefragt
    # werden sollen. Wenn möglich bitte die obige Anfrage per Attribute Exhcange verwenden!
    sregreq = OpenID::SReg::Request.new
    sregreq.request_fields(['nickname', 'email'], true) # erforderliche Attribute
    sregreq.request_fields(['fullname'], false) # optionale Attribute
    oidreq.add_extension(sregreq)
        
    # Anfrage absenden: Der erste Parameter der Redirects ist das "Trust Root",
    # die Root-URL der Anwendung, für welche der Benutzer sich authentisieren soll.
    # Zweiter Parameter ist die Adresse der complete Action (siehe Routes oben)   
   if oidreq.send_redirect?(root_url, session_complete_url)
      redirect_to oidreq.redirect_url(root_url, session_complete_url)
    else
      @form_text = oidreq.form_markup(root_url, session_complete_url, false, { 'id' => 'checkid_form' })
    end
  end

  # Die complete-Action nimmt die Antwort des OpenID-Servers entgegen
  # und verarbeitet die übergebenen Attribute
  def complete
    oidparams = params.reject{ |k,v| request.path_parameters[k] }
    oidresp = openid_consumer.complete(oidparams, url_for({}))
    # Überprüfung ob die Antwort vom OpenID-Server des Fachbereich 3 kommt. Wenn auch andere
    # Identity Provider zulässig sein sollen, dann muss diese Abfrage entfernt werden.
    if oidresp && oidresp.endpoint && oidresp.endpoint.server_url.match(identity_provider)
      # Wenn die Anfrage bestätigt wurde, wird der Benutzer anhand der OpenID identifiziert
      if oidresp.status == OpenID::Consumer::SUCCESS
	p "OPENID: ", oidresp.display_identifier
        @user, data = User.find_or_initialize_by_identity_url(oidresp.display_identifier), {}
        # Wenn Attribute übergeben wurden, werden diese dem lokalen Benutzerkonto zugewiesen.
        # An dieser Stelle ist es relativ anwendungsspezifisch, welche Daten angefordert wurden
        # und wie diese auf die Attribute des Benutzerkontos mappen, daher ist an dieser Stelle
        # Anpassungsarbeit erforderlich.
        if ax_resp = OpenID::AX::FetchResponse.from_success_response(oidresp)
          data[:login] = ax_resp.data['http://openid.tzi.de/spec/schema/uid'][0] unless ax_resp.data['http://openid.tzi.de/spec/schema/uid'][0].blank?
          data[:email] = ax_resp.data['http://openid.tzi.de/spec/schema/mail'][0] unless ax_resp.data['http://openid.tzi.de/spec/schema/mail'][0].blank?
          data[:firstname] = ax_resp.data['http://openid.tzi.de/spec/schema/givenName'][0] unless ax_resp.data['http://openid.tzi.de/spec/schema/givenName'][0].blank?
          data[:lastname] = ax_resp.data['http://openid.tzi.de/spec/schema/surName'][0] unless ax_resp.data['http://openid.tzi.de/spec/schema/surName'][0].blank?
          data[:phone] = ax_resp.data['http://openid.tzi.de/spec/schema/telephoneNumber'][0] unless ax_resp.data['http://openid.tzi.de/spec/schema/telephoneNumber'][0].blank?
          data[:homepage] = ax_resp.data['http://axschema.org/contact/web/default'][0] unless ax_resp.data['http://axschema.org/contact/web/default'][0].blank?
        elsif sreg_resp = OpenID::SReg::Response.from_success_response(oidresp)
          data[:login] = sreg_resp.data['nickname'] unless sreg_resp.data['nickname'].blank?
          data[:email] = sreg_resp.data['email'] unless sreg_resp.data['email'].blank?
          data[:fullname]  = sreg_resp.data['fullname'] unless sreg_resp.data['fullname'].blank?
        end
        # Lokales Benutzerkonto ggf. mit den Daten vo Identity Provider abgleichen
        @user.update_attributes(data) unless data.empty?
        # Den Benutzer einloggen, sofern ein lokales Benutzerkonto eingerichtet werden konnte.
        # Die Funktionen dazu (logged_in?, successful_login, etc.) sind eher als Pseudocode zu
        # sehen, da diese anwendungsspezifisch implementiert werden müssen.
        self.current_user = @user unless @user.new_record?
        logged_in? ? successful_login : failed_login('Das Login mit OpenID ist fehlgeschlagen, da erforderliche Daten nicht freigegeben wurden.')
      else
        failed_login('Das Login mit OpenID ist fehlgeschlagen.')
      end
    else
      failed_login("Es werden nur OpenIDs von #{identity_provider} akzeptiert.")
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
