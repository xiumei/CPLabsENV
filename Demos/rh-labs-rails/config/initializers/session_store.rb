require File.join(Rails.root,'lib','openshift_secret_generator.rb')

# Be sure to restart your server when you modify this file.

secret = initialize_secret(:session_store, '_session')
# Set token based on intialize_secret function (defined in initializers/secret_generator.rb)
RailsApp::Application.config.session_store :cookie_store, {
                                             :key =>           "#{secret}_#{$lab_id}",
                                             :path =>          $lab_context,
                                             :expire_after =>  60*60
                                           }

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# RailsApp::Application.config.session_store :active_record_store
