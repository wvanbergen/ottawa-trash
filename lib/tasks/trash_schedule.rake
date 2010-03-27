require 'open-uri'

namespace(:trash_schedule) do
  
  desc "Import the trash database using HTML scraping"
  task(:scrape => [:environment]) do
    
    url_template = 'http://ottawa.ca/cgi-bin/gc/gc.pl?sname=en&street=%s'
    
    days_of_week = { 'MONDAY' => 1, 'TUESDAY' => 2, 'WEDNESDAY' => 3,
      'THURSDAY' => 4, 'FRIDAY' => 5, 'SATURDAY' => 6, 'SUNDAY' => 7 }
    
    (('A'..'Z').entries + ('0'..'9').entries).each do |search|
    
      puts "Importing schedule for streets starting with '#{search}'..."
      
      url = url_template % CGI.escape(search)
      
      Nokogiri::HTML(open(url)).xpath('//table//table//tr[@bgcolor]').each do |tag|

        schedule = {}

        street_number  = tag.at_xpath('./td[1]/font').content
        street_name    = tag.at_xpath('./td[2]/font').content
        trash_day      = tag.at_xpath('./td[3]/font').content
        trash_calendar = tag.at_xpath('./td[4]//font').content

        if /(\d+)\s*-\s*(\d+)/ =~ street_number
          schedule[:start_nr], schedule[:end_nr] = $1.to_i, $2.to_i
        else
          schedule[:start_nr], schedule[:end_nr] = street_number.strip.to_i, street_number.strip.to_i
        end

        schedule[:street]      = street_name.slice(0...27).strip
        schedule[:street_type] = street_name.slice(27...34).strip
        schedule[:community]   = street_name.slice(34..-1).strip.slice(1..-2)
        
        schedule[:day]       = days_of_week[trash_day.strip]
        schedule[:calendar]  = (trash_calendar =~ /Cal(?:endar|\.) ([A-Z]).?(\*|APARTMENT)?/) ? $1 : nil
        schedule[:apartment] = ($2 == 'APARTMENT')
        schedule[:star]      = ($2 == '*')

        TrashSchedule.find_or_create_by_street_and_start_nr(schedule)
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
    TrashSchedule.icalendar_source_urls.each do |url|
      filename = TrashSchedule::ICALENDAR_DIR.join(url.split('/').last)
      File.open(filename, 'w') do |file|
        file << Net::HTTP.get(URI.parse(url))
      end
    end
  end
end

task(:bootstrap => ['db:migrate', 
                    'trash_schedule:scrape',
                    'trash_schedule:download_ical_files']) do
                      
  puts "All required data imported correctly!"
end
