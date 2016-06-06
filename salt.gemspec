Gem::Specification.new do |s|
  s.name        = 'salt'
  s.version     = '2.0.2'
  s.date        = '2015-04-24'
  s.summary     = 'salt'
  s.description = 'Library for interacting with salts API.'
  s.authors     = ['Tom Bevan', 'Raul Perez']
  s.email       = 'maintainsers@r3labs.io'
  # s.executable  = 'sea'
  s.files += Dir.glob('lib/**/*.rb')
  s.homepage = 'http://r3labs.io'
  s.add_runtime_dependency 'json', ['= 1.8.1']
  s.add_runtime_dependency 'thor', ['= 0.19.1']
end
