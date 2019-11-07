# frozen_string_literal: true


Bioturk::Application.config.instance_name = 'Your Lab'

# file is in aquarium/app/assets/images
Bioturk::Application.config.logo_path = 'aquarium-logo.png'

Bioturk::Application.config.image_server_interface = 'http://localhost:9000/images/'

#
# Configuration
#
Bioturk::Application.config.debug_tools = true # false will hide debug buttons in planner and manager
Bioturk::Application.config.krill_port = 3500
Bioturk::Application.config.krill_hostname = 'krill' # for docker NAT

#
# Set CSRF token names
#
Bioturk::Application.config.angular_rails_csrf_options = {
  cookie_name: "XSRF-TOKEN_#{Bioturk::Application.environment_name}",
  header_name: "X-XSRF-TOKEN_#{Bioturk::Application.environment_name}"
}

# Emailer
# Note: You must set up an AWS SimpleEmailService domain for this to work.
#       Also, make sure to set the environment variable AWS_REGION.
#       See config/initializers/production.rb under "email".

# Bioturk::Application.config.email_from_address = "aquarium@yourlab.org"
