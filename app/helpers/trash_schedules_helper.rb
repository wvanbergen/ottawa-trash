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
    "#{ts.street.titleize} #{ts.street_type.capitalize}"
  end
  
  def icalendar_path(ts)
    ts.icalendar_path
  end
  
  def date_distance(date)
    case date
      when Date.today then content_tag(:strong, 'today')
      when Date.today + 1 then content_tag(:strong, 'tomorrow')
      else ("in <strong>%d</strong> days" % [date - Date.today]).html_safe
    end
  end
end
