module GoogleHelper
  def google_add_event(google, event)
    google.new_event(event)
  end

  def google_auth
    g=Googlecalendar::GData.new
    begin
      g.login(Conf.google_account_name, Conf.google_account_password)
    rescue
      return nil
    end
    
    g
  end
end