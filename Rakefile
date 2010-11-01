require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cronos"
    gem.summary = "A small utility for crontab format"
    gem.description = "A small utility for crontab format"
    gem.email = "june29.jp@gmail.com"
    gem.homepage = "http://github.com/june29/cronos"
    gem.authors = ["june29"]
    gem.add_development_dependency "rspec", ">= 2.0.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
desc 'run all specs'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = ['-c']
end
