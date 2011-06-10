
namespace(:trash_schedule) do
  
  desc "Import the trash database using HTML scraping"
  task(:scrape => [:environment]) do
    
    require 'open-uri'
    
    (('A'..'Z').entries + ('0'..'9').entries).each do |search|
    
      puts "Importing schedule for streets starting with '#{search}'..."
      
      url = TrashSchedule::LOOKUP_URL_TEMPLATE % CGI.escape(search)
      Nokogiri::HTML(open(url)).xpath('//table//table//tr[@bgcolor]').each do |tag|

        schedule = {}

        street_number  = tag.at_xpath('./td[1]/font').content
        street_name    = tag.at_xpath('./td[2]/font').content
        trash_day      = tag.at_xpath('./td[3]/font').content
        trash_calendar = tag.at_xpath('./td[4]//font').content

        if street_number.blank?
          schedule[:start_no], schedule[:end_no] = nil, nil
        elsif /(\d+)\s*-\s*(\d+)/ =~ street_number
          schedule[:start_no], schedule[:end_no] = $1.to_i, $2.to_i
        else
          schedule[:start_no], schedule[:end_no] = street_number.strip.to_i, street_number.strip.to_i
        end

        schedule[:street]      = street_name.slice(0...27).strip
        schedule[:street_type] = street_name.slice(27...34).strip
        schedule[:community]   = street_name.slice(34..-1).strip.slice(1..-2)
        
        schedule[:day]       = TrashSchedule::DAYS[trash_day.strip.capitalize]
        schedule[:calendar]  = (trash_calendar =~ /Cal(?:endar|\.) ([A-Z]).?(\*|APARTMENT)?/) ? $1 : nil
        schedule[:apartment] = ($2 == 'APARTMENT')
        schedule[:star]      = ($2 == '*')

        TrashSchedule.find_or_create_by_street_and_start_no(schedule)
      end

      # Now, give the city's servers some time to breathe.
      sleep(1.0)
    end
    
    puts "Done importing schedules!"
  end
  
  desc "Downloads the iCal files describing the trash schedule"
  task(:download_ical_files => :environment) do
    # Make sure the target directory exists
    FileUtils.mkdir_p(TrashSchedule::ICALENDAR_DIR)
    
    # Now, get every schedule variant.
    TrashSchedule.each_icalendar_source_url do |schedule, day, url|

      puts "Downloading #{day} variant for schedule #{schedule}..."

      # Build the filename
      filename = "%s_%s.ics" % [schedule.downcase, day.downcase]
      path = TrashSchedule::ICALENDAR_DIR.join(filename)
      
      # Download the file and store it locally.
      File.open(path, 'w') { |f| f << Net::HTTP.get(URI.parse(url)) }
      sleep(1.0) # ... and rest for a bit!
    end
    puts "Downloaded all iCalendar files!"
  end
end

desc "Bootstrap Ottawa Garbage Collection [all setup tasks in one command]"
task(:bootstrap => ['db:setup', 
                    'trash_schedule:scrape',
                    'trash_schedule:download_ical_files']) do

  puts "All required data imported correctly!"
end
