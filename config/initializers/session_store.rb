# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_ottawa_trash_session',
  :secret => '69bd11cdb7d66a00bbc6522ae057bfaa18da86630ff58d36e4a4d38297fabd1b8f35bb54975bc8518cc462f069c5454dd5e62c590a2f0c1d13d811e0d838e920'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
