# Measure test coverage
require 'coveralls'
Coveralls.wear_merged!

ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'webmock/minitest'

# If tests are running under JRuby, load the right database configuration

if JRUBY_VERSION
  configs = YAML.load_file(Rails.root.join('config', 'database.yml'))
  ActiveRecord::Base.configurations = configs['jruby']

  ActiveRecord::Base.establish_connection(:test)
  ActiveRecord::Base.default_timezone = :utc
end

# Use Mocha for mocking/stubbing
require 'mocha/setup'

# Uncomment for awesome colorful output
require 'minitest/pride'

# Require miniskirt factories
Dir[Rails.root.join('test', 'factories', '**', '*.rb')].each { |f| require f }

# Allow RSpec-style context blocks
class ActiveSupport::TestCase
  class << self
    alias :context :describe
  end
end

# Allow POST requests with bodies
class ActionController::TestCase
  def raw_post(action, params, body)
    @request.env['RAW_POST_DATA'] = body
    response = post(action, params)
    @request.env.delete('RAW_POST_DATA')
    response
  end
end
