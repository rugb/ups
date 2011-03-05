module GoogleHelper
  def google_add_event(google, event)
    cal = google_find_calendar(google, Conf.google_calendar_id)
    event = GCal4Ruby::Event.new(google, event.merge(:calendar => cal))
    saved = event.save

    return {:saved => saved, :event => event}
  end

  def google_find_event(google, eventid)
    event = GCal4Ruby::Event.find(google, {:id => eventid}, {:calendar => Conf.google_calendar_id})
  end

  def google_find_calendar(google, id)
    GCal4Ruby::Calendar.find(google, {:id => id})
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