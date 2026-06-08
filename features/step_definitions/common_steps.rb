require 'capybara/dsl'
require 'rspec/expectations'

def form
  @form ||= Form.new
end

Dado("que me encuentro en la página de inicio de DemoBlaze") do
  visit "/"
  expect(page).to have_css("#navbarExample", wait: 10)
end

def wait_for_alert(timeout: 5)
  start = Time.now
  loop do
    begin
      return page.driver.browser.switch_to.alert
    rescue Selenium::WebDriver::Error::NoSuchAlertError
      raise if Time.now - start >= timeout
      sleep 0.3
    end
  end
end

Entonces("debería ver el mensaje de alerta {string}") do |expected_message|
  alert = wait_for_alert
  expect(alert.text).to eq(expected_message)
  alert.accept
end

Entonces("debería mostrar un mensaje de error") do
  expect do
    alert = wait_for_alert
    alert.accept
  end.not_to raise_error
end
