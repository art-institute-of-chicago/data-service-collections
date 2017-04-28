require 'grape'
require 'rsolr'

require_relative 'conf.rb'
require_relative '../helpers/error_formatter.rb'
require_relative '../helpers/lake_unwrapper.rb'
require_relative '../models/base_model.rb'
Dir.glob(File.expand_path('../models/*.rb', __dir__)).each do |file|
  require_relative file
end
