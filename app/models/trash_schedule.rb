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

end
