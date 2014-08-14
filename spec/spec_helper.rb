# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
#
ENV["RACK_ENV"] = "test"

require "bundler"
Bundler.require(:default, :test)

root = File.expand_path("../../", __FILE__)
ENV.update(Pliny::Utils.parse_env("#{root}/.env.test"))

require_relative "../lib/initializer"
require_relative "factories"

# N.B.: Some of our tests rely on concurrently accessing transfers, we
# can't use the faster transcation strategy everywhere. TODO: is it
# possible to use truncation in only some tests (it is possible on
# only some tables, but given that transfers is pretty central, that
# may be a moot point). Note that we omit the app_status table, since
# its contents are really more a part of the schema than the data
# model.
DatabaseCleaner.strategy = :truncation, {:except => %w[app_status]}

# pull in test initializers
Pliny::Utils.require_glob("#{Config.root}/spec/support/**/*.rb")

RSpec.configure do |config|

  config.before :all do
    load('db/seeds.rb') if File.exist?('db/seeds.rb')
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Enable old rspec syntax for now since some things are tricky with
  # new syntax; we should revisit this and strip it out
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |c|
    c.syntax = :should
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  # the rack app to be tested with rack-test:
  def app
    @rack_app || fail("Missing @rack_app")
  end
end
