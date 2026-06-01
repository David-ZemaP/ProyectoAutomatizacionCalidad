
Dado("estoy en la página de inicio de DemoBlaze") do
  visit "/"
  expect(page).to have_css("#navbarExample", wait: 10)
end

def form
  @form ||= Form.new
end

Cuando("hago clic en {string}") do |link_text|
  case link_text.downcase
  when "sign up"
    find("#signin2", wait: 10).click
  when "log in"
    find("#login2", wait: 10).click
  else
    click_link(link_text, match: :first)
  end
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

Entonces("debería mostrar un mensaje de error") do
  expect do
    alert = wait_for_alert
    alert.accept
  end.not_to raise_error
end

Entonces("debería aparecer un alert con el mensaje {string}") do |expected_message|
  alert = wait_for_alert
  expect(alert.text).to eq(expected_message)
  alert.accept
end
