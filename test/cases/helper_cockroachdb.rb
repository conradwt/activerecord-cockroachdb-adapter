require 'bundler/setup'
Bundler.require :development

# Turn on debugging for the test environment
ENV['DEBUG_COCKROACHDB_ADAPTER'] = "1"

# Load ActiveRecord test helper
require "cases/helper"

# Load the CockroachDB specific schema. It replaces ActiveRecord's PostgreSQL
# specific schema.
def load_cockroachdb_specific_schema
  # silence verbose schema loading
  original_stdout = $stdout
  $stdout = StringIO.new

  load "schema/cockroachdb_specific_schema.rb"

  ActiveRecord::FixtureSet.reset_cache
ensure
  $stdout = original_stdout
end

if ENV['COCKROACH_LOAD_FROM_TEMPLATE'].nil? && ENV['COCKROACH_SKIP_LOAD_SCHEMA'].nil?
  load_cockroachdb_specific_schema
elsif ENV['COCKROACH_LOAD_FROM_TEMPLATE']
  require 'support/template_creator'

  p "loading schema from template"

  # load from template
  TemplateCreator.restore_from_template

  # reconnect to activerecord_unittest
  ARTest.connect
end

require 'timeout'

module TestTimeoutHelper
  def time_it
    t0 = Minitest.clock_time

    Timeout.timeout(180, Timeout::Error, 'Test took over 3 minutes to finish') do
      yield
    end
  ensure
    self.time = Minitest.clock_time - t0
  end
end

# Retry tests that fail due to foreign keys not always being removed synchronously
# in disable_referential_integrity, which causes foreign key errors during
# fixutre creation.
#
# Can be removed once cockroachdb/cockroach#71496 is resolved.
module TestRetryHelper
  def run_one_method(klass, method_name, reporter)
    reporter.prerecord(klass, method_name)
    final_res = nil
    2.times do
      res = Minitest.run_one_method(klass, method_name)
      final_res ||= res

      retryable = false
      if res.error?
        res.failures.each do |f|
          retryable = true if f.message.include?("ActiveRecord::InvalidForeignKey")
        end
      end
      (final_res = res) && break unless retryable
    end

    # report message from first failure or from success
    reporter.record(final_res)
  end
end

module ActiveSupport
  class TestCase
    extend TestRetryHelper
    include TestTimeoutHelper

    def postgis_version
      @postgis_version ||= ActiveRecord::Base.connection.select_value('SELECT postgis_lib_version()')
    end

    def factory
      RGeo::Cartesian.preferred_factory(srid: 3857)
    end

    def geographic_factory
      RGeo::Geographic.spherical_factory(srid: 4326)
    end

    def spatial_factory_store
      RGeo::ActiveRecord::SpatialFactoryStore.instance
    end
  end
end
