class TrashSchedule < ActiveRecord::Base

  SCHEDULES = ['A', 'B', 'C', 'D']
  DAYS      = { 'Monday' => 1, 'Tuesday' => 2, 'Wednesday' => 3,
                'Thursday' => 4, 'Friday' => 5 }

  ICALENDAR_DIR = Rails.root.join('public', 'schedules')
  ICALENDAR_SOURCE_URL = 'http://www.shawnhooper.ca/projects/ottawa-garbage-ical/gcc_%s_%s.ics'

  def self.icalendar_source_urls
    urls = []
    SCHEDULES.each do |schedule|
      DAYS.each do |day, index|
        urls << ICALENDAR_SOURCE_URL % [schedule.downcase, day.downcase]
      end
    end
    urls
  end

end
