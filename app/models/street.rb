class Street < ActiveRecord::Base
  
  validates_uniqueness_of :full_name, :case_sensitive => false
  
  DIRECTIONS = ['North', 'East', 'West', 'South', 'N', 'E', 'W', 'S']
  
  COMMON_PREFIXES = [
      'Rue',
      'Boulevard',
      'Promenade'
    ]

  COMMON_SUFFIXES = [
      'Avenue', 'Parkway', 'Driveway', 'Parkway', 'Road', 'Drive', 'Place', 
      'Bridge', 'Street', 'Boulevard', 'Dr', 'Ave', 'St'
    ]
  
  def self.cleanup_directions_regexp
    suffix_regexp = Regexp.new(' ' + Regexp.union(DIRECTIONS).to_s + '$', 'i')
  end
    
  def self.parse_regexp
    @regexp ||= begin
      prefix_regexp = Regexp.new('^(?:(' + Regexp.union(COMMON_PREFIXES).to_s + ') )?', 'i')
      suffix_regexp = Regexp.new('(?: (' + Regexp.union(COMMON_SUFFIXES).to_s + '))?$', 'i')
      Regexp.new(prefix_regexp.to_s + '(.*?)' + suffix_regexp.to_s)
    end
  end

  def self.parse(full_street_name)
    # Cleanup
    full_street_name.sub!(cleanup_directions_regexp, '')

    # Parse what's left
    if parse_regexp =~ full_street_name
      Street.new(:full_name => full_street_name,
        :name => $2, :prefix => $1, :suffix => $3)
    else
      nil
    end
  end
  
end
