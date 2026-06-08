Cuando("inicio sesión con el usuario {string} y la contraseña {string}") do |username, password|
  find("#login2", wait: 10).click
  expect(page).to have_css("#logInModal.show", visible: true, wait: 5)
  
  within("#logInModal") do
    find("#loginusername", wait: 5).set(username)
    find("#loginpassword", wait: 5).set(password)
    click_button("Log in")
  end
end

Entonces("debería ver el saludo de bienvenida para el usuario {string}") do |username|
  expect(page).to have_css("#nameofuser", visible: true, wait: 15)
  expect(find("#nameofuser").text).to eq("Welcome #{username}")
  expect(page).to have_css("#logout2", visible: true, wait: 10)
  expect(page).to have_no_css("#login2", visible: true, wait: 10)
  expect(page).to have_no_css("#signin2", visible: true, wait: 10)
end

Entonces("no debería ingresar a la cuenta") do
  begin
    page.driver.browser.switch_to.alert.accept
  rescue Selenium::WebDriver::Error::NoSuchAlertError
  end

  expect(page).to have_no_css("#nameofuser", visible: true, wait: 5)
  expect(page).to have_no_css("#logout2", visible: true, wait: 5)
  expect(page).to have_css("#login2", visible: true, wait: 5)
  expect(page).to have_css("#signin2", visible: true, wait: 5)
end

Cuando("abro el formulario de inicio de sesión") do
  find("#login2", wait: 10).click
  expect(page).to have_css("#logInModal.show", visible: true, wait: 5)
end

Cuando("cierro el formulario usando el método {string}") do |método|
  within("#logInModal") do
    case método
    when "Close"
      click_button("Close")
    when "X"
      find(".close", wait: 5).click
    else
      raise "Método de cierre desconocido: #{método}"
    end
  end
  sleep 0.5
  page.execute_script("$('#logInModal').modal('hide')") rescue nil
end

Entonces("el formulario de inicio de sesión debería cerrarse") do
  expect(page).to have_no_css("#logInModal.show", visible: true, wait: 5)
  expect(page).to have_no_css(".modal-backdrop", visible: true, wait: 5)
  expect(page).to have_css("#login2", visible: true, wait: 5)
end