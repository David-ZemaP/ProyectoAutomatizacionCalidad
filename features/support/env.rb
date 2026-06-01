require 'fileutils'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'
require_relative 'form'

ENV['USER']="Pepazo"
ENV['PSW']="ILoveQA"

Capybara.default_driver = :selenium

Capybara.app_host = ENV["CAPYBARA_HOST"]

Capybara.default_max_wait_time = 15
Capybara.default_driver = :selenium
Capybara.app_host = "https://www.demoblaze.com"

Capybara.register_driver :chrome_testing do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :chrome_testing
Capybara.javascript_driver = :chrome_testing

Capybara.run_server = false
Capybara.default_driver = :chrome_testing
Capybara.javascript_driver = :chrome_testing

RUN_ONCE_DIR = File.join(__dir__, "..", ".run_once")

Before("@first_run_only") do |scenario|
  marker = File.join(RUN_ONCE_DIR, scenario.name.gsub(/\s+/, "_").gsub(/[^\w]/, "").downcase + ".marker")
  @run_once_marker = marker

  if File.exist?(marker)
    skip_this_scenario("Ya se ejecutó: #{scenario.name}")
  end
end

After("@first_run_only") do
  FileUtils.mkdir_p(RUN_ONCE_DIR)
  File.write(@run_once_marker, "Ejecutado el: #{Time.now}")
end
