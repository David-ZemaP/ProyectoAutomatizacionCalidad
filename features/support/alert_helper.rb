module AlertHelper
  def esperar_alerta(timeout: 5)
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

  def validar_alerta(mensaje_esperado, timeout: 5)
    alert = esperar_alerta(timeout: timeout)
    expect(alert.text).to eq(mensaje_esperado)
    alert.accept
  end

  def aceptar_alerta(timeout: 5)
    alert = esperar_alerta(timeout: timeout)
    alert.accept
  end

  def existe_alerta?(timeout: 2)
    start = Time.now
    loop do
      begin
        page.driver.browser.switch_to.alert
        return true
      rescue Selenium::WebDriver::Error::NoSuchAlertError
        return false if Time.now - start >= timeout
        sleep 0.3
      end
    end
  end
end

World(AlertHelper) if respond_to?(:World)
