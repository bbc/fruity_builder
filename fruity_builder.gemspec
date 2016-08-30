Gem::Specification.new do |s|
  s.name        = 'fruity_builder'
  s.version     = '1.1.1'
  s.date        = Time.now.strftime('%Y-%m-%d')
  s.summary     = 'iOS code signing utilities'
  s.description = 'iOS code signing utilities - used to replace bundle IDs, development teams and provisioning profiles programmatically'
  s.authors     = ['BBC', 'Jon Wilson']
  s.email       = ['jon.wilson01@bbc.co.uk']
  s.files       = Dir['README.md', 'lib/**/*.rb']
  s.homepage    = 'https://github.com/bbc/fruity_builder'
  s.license     = 'MIT'
  s.add_runtime_dependency 'ox', '>=2.1.0'
end
