require 'yaml'

COLLECTIONS_URL = begin
                    YAML.load_file(File.join(__dir__, 'conf.yaml')).fetch('collections_url')
                  rescue Errno::ENOENT, KeyError
                    '.'
                  end
