# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_Jilion.com_session',
  :secret      => '18be2edd5bb62b9b9c54304727b0c828c41ded5eae9b322c7e0c4b2fb710c947d6a78c2a30f70df87caf391ecce9647938bfa2ef29bbc4ad8ccbf9d8fce4e03d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
