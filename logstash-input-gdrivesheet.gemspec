Gem::Specification.new do |s|
  s.name = 'logstash-input-gdrivesheet'
  s.version         = '0.1.0'
  s.licenses = ['Apache License (2.0)']
  s.summary = "Logstash pull from google spreadsheet with service account"
  s.description = "TODO"
  s.authors = ["derickson"]
  s.require_paths = ["lib"]

  # Files
  s.files = `git ls-files`.split($\)
   # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "input" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core", '>= 1.4.0', '< 2.0.0'
  s.add_runtime_dependency 'logstash-codec-plain'
  s.add_runtime_dependency 'stud'
  s.add_runtime_dependency 'google-api-client', '0.9.pre1'
  s.add_runtime_dependency 'google_drive', '1.0.1'
  s.add_development_dependency 'logstash-devutils'
end