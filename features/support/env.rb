
require 'fileutils'
begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara'
require 'capybara/dsl'
require 'capybara/cucumber'
require 'capybara-screenshot/cucumber'
require 'selenium-webdriver'

#PTravel Settings
ENV['USER']="Pepazo"
ENV['PSW']="ILoveQA"

Capybara.default_driver = :selenium

# Set the host the Capybara tests should be run against
Capybara.app_host = ENV["CAPYBARA_HOST"]

# Set the time (in seconds) Capybara should wait for elements to appear on the page
Capybara.default_max_wait_time = 15
Capybara.default_driver = :selenium
Capybara.app_host = "https://www.demoblaze.com"


# Registramos el driver de Chrome para que Capybara lo use
Capybara.register_driver :chrome_testing do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  # Al instanciar Capybara::Selenium::Driver, se ejecuta Selenium Manager internamente
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

# Asignamos el driver registrado como el predeterminado para tus pruebas
Capybara.default_driver = :chrome_testing
Capybara.javascript_driver = :chrome_testing


Capybara.run_server = false
#World(Capybara)
Capybara.default_driver = :chrome_testing
Capybara.javascript_driver = :chrome_testing

# Marcadores para escenarios @first_run_only (un archivo por scenario)
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
