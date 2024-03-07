require 'june/analytics'


Analytics = June::Analytics.new({
                                  write_key: 'On8QN8DuZzrj8c7R',
                                  on_error: proc { |_status, msg| print msg },
                                  test: !Rails.env.production?
                                })