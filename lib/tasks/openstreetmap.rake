
namespace(:openstreetmap) do
  
  desc "Downloads OpenStreetmap data for street names on Ottawa"
  task(:download) do

    coords   = [-75.7283, 45.4016, -75.6649, 45.4388]
    base_url = 'http://api.openstreetmap.org/api/0.6/map?bbox='

    filename = Rails.root.join('db', 'data', 'ottawa.osm.xml')
    url = base_url + coords.join(',')

    `wget #{url} -O #{filename}`
  end
  
  desc "Imports street names from OpenStreetmap data"
  task(:import_streets => :environment) do

    filename = Rails.root.join('db', 'data', 'ottawa.osm.xml')
    doc      = Nokogiri::XML(open(filename))

    doc.xpath("//way[tag[@k='highway']]/tag[@k='name']/@v").each do |tag|
      streetname = tag.content
      puts "Saving #{streetname}"
      Street.parse(tag.content).save! rescue nil
    end
  end
end
