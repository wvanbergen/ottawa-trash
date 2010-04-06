class TrashSchedule < ActiveRecord::Base

  SCHEDULES = ['A', 'B', 'C', 'D']
  DAYS      = { 'Monday' => 1, 'Tuesday' => 2, 'Wednesday' => 3,
                'Thursday' => 4, 'Friday' => 5 }

  ICALENDAR_DIR = Rails.root.join('public', 'schedules')

  ICALENDAR_SOURCE_URL_TEMPLATE = 'http://www.shawnhooper.ca/projects/ottawa-garbage-ical/gcc_%s_%s.ics'
  LOOKUP_URL_TEMPLATE           = 'http://ottawa.ca/cgi-bin/gc/gc.pl?sname=en&street=%s'
  PDF_SCHEDULE_URL_TEMPLATE     = 'http://ottawa.ca/residents/recycling_garbage/collection_calendar/calendar_%s/%s_calendar_2010_2011.pdf'
  
  STREET_SUFFIXES = ['St', 'Street', 'Drive', 'Dr', 'Ave', 'Avenue', 'Lane',
      'Parkway', 'Pkwy', 'Square', 'Sq', 'Driveway', 'Drwy', 'Bridge', 'Br',
      'Place', 'Boulevard', 'Blvd', 'Way', 'Cres', 'Crescent']
  
  def self.each_icalendar_source_url(&block)
    if block_given?
      SCHEDULES.each do |schedule|
        DAYS.each do |day, index|
          url = ICALENDAR_SOURCE_URL_TEMPLATE % 
                    [CGI.escape(schedule.downcase), CGI.escape(day.downcase)]

          yield(schedule, day, url)
        end
      end
    else
      Enumerable::Enumerator.new(self, :each_icalendar_source_url)
    end
  end

  def self.suffix_regexp
    @suffix_regexp ||= begin
      suffixes = STREET_SUFFIXES.map { |s| Regexp.quote(s) }.join('|')
      Regexp.new("\s+(?:#{suffixes})$", 'i')
    end
  end

  def self.search(q)
    if q =~ /(?:(\d+)\s+)?(.+)/
      number, street = $1, $2
      
      trash_schedules = TrashSchedule.with_street(street)
      trash_schedules = trash_schedules.with_number(number) if number
      return trash_schedules
    else
      self
    end
  end

  def self.with_street(street)
    street_name = street.strip.sub(suffix_regexp, '').upcase
    where("street LIKE ?", "#{street_name}%")
  end

  def self.with_number(number)
    where("(start_no IS NULL AND end_no IS NULL) OR (start_no <= ? AND end_no >= ?)", number.to_i, number.to_i)
  end

  def self.in_number_range(lower_bound, upper_bound)
    where("(start_no IS NULL AND end_no IS NULL) OR (start_no <= ? AND end_no >= ?)", upper_bound.to_i, lower_bound.to_i)    
  end

  def icalendar_file
    self.class.icalendar_file(calendar, DAYS.invert[day])
  end
  
  def icalendar_path
    "/schedules/%s_%s.ics" % [calendar.downcase, DAYS.invert[day].downcase]
  end
  
  
  def self.icalendar(file)
    @icalendar_cache ||= {}
    @icalendar_cache[file] ||= RiCal.parse_string(File.read(file)).first
  end
  
  def icalendar
    @icalender ||= self.class.icalendar(icalendar_file)
  end

  def self.icalendar_file(schedule, day)
    ICALENDAR_DIR.join('%s_%s.ics' % [schedule.downcase, day.downcase])
  end
  
  def self.pdf_schedule_url(schedule)
    PDF_SCHEDULE_URL_TEMPLATE % [schedule.downcase, schedule.downcase]
  end
  
  def pdf_schedule_url
    self.class.pdf_schedule_url(calendar)
  end
  
  def next_event_with_summary(summary, after = Date.today, max_search = 2.months)
    icalendar.events.each do |event|
      if summary === event.summary
        event.occurrences(:overlapping => [after, after + max_search]).each do |occurrence|
          return occurrence.dtstart
        end
      end
    end
    return nil
  end
  
  def next_regular
    next_event_with_summary(/^(?:Blue|Green|Black) /i)
  end
  
  def next_blue_box
    next_event_with_summary(/^Blue box/i)
  end
  
  def next_green_bin
    next_event_with_summary(/^Green bin/i)
  end
  
  def next_black_box
    next_event_with_summary(/^Black box/i)
  end
end
