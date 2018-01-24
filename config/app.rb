require 'grape'
require 'rsolr'

require 'active_support/inflector'

require_relative 'conf.rb'

# The order matters here, so we'll load them manually
require_relative '../helpers/error_formatter.rb'
require_relative '../helpers/lake_unwrapper.rb'
require_relative '../helpers/lake_to_citi_id.rb'
require_relative '../helpers/uri_to_guid.rb'
require_relative '../helpers/str_to_int.rb'
require_relative '../helpers/uid_to_id.rb'
require_relative '../helpers/model_base.rb'
require_relative '../helpers/model_resource.rb'

Dir.glob(File.expand_path('../models/*.rb', __dir__)).each do |file|
  require_relative file
end
