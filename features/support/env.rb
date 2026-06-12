require 'fileutils'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'selenium-webdriver'
require_relative 'form'
require_relative 'page_objects_helper'
require_relative 'constants'

ENV['USER']="Pepazo"
ENV['PSW']="ILoveQA"

Capybara.app_host = DemoblazeConstants::BASE_URL

Capybara.register_driver :chrome_testing do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver = :chrome_testing
Capybara.javascript_driver = :chrome_testing
Capybara.run_server = false
Capybara.default_max_wait_time = 15
