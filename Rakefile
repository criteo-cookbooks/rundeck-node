require 'rspec/core/rake_task'
require 'foodcritic'
require 'kitchen'

FoodCritic::Rake::LintTask.new
RSpec::Core::RakeTask.new(:rspec)

desc "Run kitchen tests sequentially"
task :ec2_sequential do
  Kitchen.logger = Kitchen.default_file_logger
  @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.ec2.yml')
  config = Kitchen::Config.new(loader: @loader)
  config.instances.each do |instance|
    instance.test(:always)
  end
end

desc "Run kitchen tests concurrently"
task :ec2_concurrent do
  Kitchen.logger = Kitchen.default_file_logger
  @loader = Kitchen::Loader::YAML.new(project_config: './.kitchen.ec2.yml')
  config = Kitchen::Config.new(loader: @loader)
  threads = []
  config.instances.each do |instance|
    threads << Thread.new do
      instance.test(:always)
    end
  end
  threads.map(&:join)
end

if ENV['KITCHEN_NO_CONCURRENCY']
  task default: [:foodcritic, :rspec, :ec2_sequential]
else
  task default: [:foodcritic, :rspec, :ec2_concurrent]
end
