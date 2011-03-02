module GoogleHelper
  def google_add_event(google, event)
    event = GCal4Ruby::Event.new(google, event.merge(:calendar => google.calendars[0]))
    saved = event.save

    return {:saved => saved, :event => event}
  end

  def google_find_event(google, eventid)
    event = GCal4Ruby::Event.find(google, {:id => eventid}, {:calendar => google.calendars[0].id})
  end

  def google_auth
    g = GCal4Ruby::Service.new
    begin
      g.authenticate(Conf.google_account_name, Conf.google_account_password)
      g.debug = true
    rescue
      return nil
    end
    
    g
  end
end