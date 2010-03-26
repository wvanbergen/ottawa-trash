require 'open-uri'

namespace(:trash) do
  
  desc "Import the trash database using the street database"
  task(:import => [:environment]) do
    url_template = 'http://ottawa.ca/cgi-bin/gc/gc.pl?sname=en&street=%s'
    
    Street.find_each do |street|
    
      url = url_template % CGI.escape(street.name)
      
      Nokogiri::HTML(open(url)).xpath('//table//table//tr[@bgcolor]').each do |tag|
        street_number  = tag.at_xpath('./td[1]/font').content
        street_name    = tag.at_xpath('./td[2]/font').content
        trash_day      = tag.at_xpath('./td[3]/font').content
        trash_calendar = tag.at_xpath('./td[4]//font').content
      
        if /(\d+)\s*-\s*(\d+)/ =~ street_number
          start_nr, end_nr = $1.to_i, $2.to_i
        else
          start_nr, end_nr = street_number.strip.to_i, street_number.strip.to_i
        end
      
        street = street_name.slice(1..25).strip
      
        day = case trash_day.strip
          when 'MONDAY'    then 1
          when 'TUESDAY'   then 2
          when 'WEDNESDAY' then 3
          when 'THURSDAY'  then 4
          when 'FRIDAY'    then 5
          when 'SATURDAY'  then 6
          when 'SUNDAY'    then 7
          else p trash_day; nil
        end
      
        calendar = (trash_calendar =~ /Cal(?:endar|\.) ([A-Z]).?(\*|APARTMENT)?/) ? $1 : nil
      
        TrashSchedule.find_or_create_by_street_and_start_nr(:start_nr => start_nr, 
            :end_nr => end_nr, :street => street, :calendar => calendar, :day => day,
            :apartment => ($2 == 'APARTMENT'), :star => ($2 == '*'))
            
        sleep(0.5)
      end
    end
  end
end