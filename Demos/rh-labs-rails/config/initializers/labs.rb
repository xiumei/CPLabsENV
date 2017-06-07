Rails.application.config.before_initialize do
  $lab_id = 'labsdemoapprails'
  $lab_name = 'Rails Demo Application'
  $lab_cache_buster = "bust=0.0.0"
  $lab_context = "/labs/#{$lab_id}"
  $is_prod_gear = ENV['HOME'].eql? "labsprod"
  Rails.application.config.assets.prefix = "#{$lab_context}/assets"
  Rails.application.config.action_controller.relative_url_root = $lab_context
  ENV['RAILS_RELATIVE_URL_ROOT'] = $lab_context
end
