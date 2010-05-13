require 'rubygems'
require 'spec/rake/spectask'
require 'rcov/rcovtask'
require 'rake'

task :default => :spec
 
desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/*_spec.rb']
  t.spec_opts = %w(-fs --color --backtrace)
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec/*,gems/*']
end


desc "Build rhodes-translator gem"
task :gem => [ 'spec', 'clobber_spec', :gemspec, :build ]

begin
  require 'jeweler'

  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "rhodes-translator"
    gemspec.summary = %q{Rhodes Metadata}
    gemspec.description = %q{Extension that provides metadata capability for the Rhodes framework}
    gemspec.homepage = %q{http://rhomobile.com/}
    gemspec.authors = ["Rhomobile"]
    gemspec.email = %q{dev@rhomobile.com}
    gemspec.version = "0.0.1"
    gemspec.files =  FileList["{lib}/**/*"].to_a

  end
rescue LoadError
  puts "Jeweler not available. Install it with: "
  puts "gem install jeweler\n\n"
end

