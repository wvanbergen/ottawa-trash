class TrashSchedule < ActiveRecord::Base

  SCHEDULES = ['A', 'B', 'C', 'D']
  DAYS      = { 'Monday' => 1, 'Tuesday' => 2, 'Wednesday' => 3,
                'Thursday' => 4, 'Friday' => 5 }

  ICALENDAR_DIR = Rails.root.join('public', 'schedules')
  ICALENDAR_SOURCE_URL_TEMPLATE = 'http://www.shawnhooper.ca/projects/ottawa-garbage-ical/gcc_%s_%s.ics'

  LOOKUP_URL_TEMPLATE = 'http://ottawa.ca/cgi-bin/gc/gc.pl?sname=en&street=%s'

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

  def self.search(q)
    if q =~ /(?:(\d+)\s+)?(.+)/
      number, street = $1, $2
      trash_schedules = TrashSchedule.with_street(street)
      trash_schedules = @trash_schedules.with_number(number) if number
      return trash_schedules
    else
      self
    end
  end

  def self.with_street(street)
    where("street LIKE ?", "#{street.strip.upcase}")
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
  
  def icalendar
    RiCal.parse_string(File.read(icalendar_file))
  end

  def self.icalendar_file(schedule, day)
    ICALENDAR_DIR.join('%s_%s.ics' % [schedule.downcase, day.downcase])
  end
end
