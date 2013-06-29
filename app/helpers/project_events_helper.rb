module ProjectEventsHelper
  def add_to_g_cal(event)
    "http://www.google.com/calendar/event?action=TEMPLATE&text=#{url_encode(event.name)}" +
    "&dates=#{event.ics_start_datetime}%2f#{event.ics_end_datetime}" +
    "&details=#{url_encode(event.ics_description(project_project_event_url(event.project, event)))}" + "&location=#{url_encode(event.ics_location)}"
  end
  
  def add_to_y_cal(event)
    "http://calendar.yahoo.com?v=60&VIEW=d" +
      "&TITLE=#{url_encode(event.name)}" +
      "&ST=#{event.ics_start_datetime}" +
      "&DUR=#{yahoo_duration(event)}" +
      "&DESC=#{url_encode(event.ics_description(project_project_event_url(event.project, event)))}" +
      "&in_loc=#{url_encode(event.ics_location)}"
  end
  
  def g_cal_subscribe(event)
    "http://www.google.com/calendar/render?cid=#{formatted_event_url(event, "ics")}"
  end
  
  def yahoo_duration(event)
    duration_sec = event.duration_in_sec
    return 0 if duration_sec.nil? || duration_sec == 0
    
    duration_hrs = duration_sec / 3600
    duration_mins = duration_sec / 60 - (duration_hrs * 60)
    
    "#{format_yahoo_duration(duration_hrs)}" + "#{format_yahoo_duration(duration_mins)}"
  end
  
  def format_yahoo_duration(val)
    val < 10 ? "0#{val}": val
  end
end
