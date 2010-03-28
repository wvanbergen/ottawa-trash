module TrashSchedulesHelper
  
  def display_address(ts)
    if ts.start_no.nil?
      display_street(ts)
    elsif ts.start_no == ts.end_no
      "#{ts.start_no} #{display_street(ts)}"
    else
      "#{ts.start_no}-#{ts.end_no} #{display_street(ts)}"
    end
  end
  
  def display_street(ts)
    "#{ts.street.capitalize} #{ts.street_type.capitalize}"
  end
  
  def icalendar_path(ts)
    ts.icalendar_path
  end
end
