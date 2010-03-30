class Subscription < ActiveRecord::Base
  
  validates :email,    :uniqueness => true, :format => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i

  validates :calendar, :presence => true
  validates :day,      :presence => true
  
end
