Gem::Specification.new do |s|
  s.name = 'cinch-pivotaltracker'
  s.version = '0.0.1'
  s.summary = 'A Pivotal Tracker plugin for the Cinch framework'
  s.description = 'A Pivotal Tracker plugin for the Cinch framework'
  s.authors = ['James Cartledge']
  s.email = ['jcartledge@gmail.com']
  s.homepage = ''
  s.required_ruby_version = '>= 1.9.1'
  s.files = Dir['LICENSE', 'README.md', '{lib,examples}/**/*']
  s.add_dependency("cinch", "~> 1.0")
  s.add_dependency("pivotal-tracker", "~> 0.4.1")
end
