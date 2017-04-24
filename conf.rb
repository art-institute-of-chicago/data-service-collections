require 'yaml'

COLLECTIONS_URL = begin
                    YAML.load_file('conf.yml').fetch('collections_url')
                  rescue Errno::ENOENT, KeyError
                    '.'
                  end

puts COLLECTIONS_URL
