require 'yaml'

COLLECTIONS_URL = begin
                    YAML.load_file('conf.yaml').fetch('collections_url')
                  rescue Errno::ENOENT, KeyError
                    '.'
                  end

puts COLLECTIONS_URL
