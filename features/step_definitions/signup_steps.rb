# -------------------------------------------------------------------
# Mapeo de IDs del DOM de DemoBlaze
# -------------------------------------------------------------------
SIGNUP_FIELD_IDS = {
  "username" => "sign-username",
  "password" => "sign-password"
}.freeze

LOGIN_FIELD_IDS = {
  "username" => "loginusername",
  "password" => "loginpassword"
}.freeze

# -------------------------------------------------------------------
# Given
# -------------------------------------------------------------------
Dado("estoy en la página de inicio de DemoBlaze") do
  visit "/"
  expect(page).to have_css("#navbarExample", wait: 10)
end

# -------------------------------------------------------------------
# When - Registro
# -------------------------------------------------------------------
Cuando("me registro con el usuario {string} y contraseña {string}") do |username, password|
  @saved_username = username

  find("#signin2", wait: 10).click
  expect(page).to have_css("#signInModal.show", visible: true, wait: 5)

  within("#signInModal") do
    find("#sign-username", wait: 5).set(username)
    find("#sign-password", wait: 5).set(password)
    sleep 1
    click_button("Sign up")
  end

  sleep 2
  page.driver.browser.switch_to.alert.accept

  if page.has_css?("#signInModal.show", visible: true, wait: 3)
    within("#signInModal") do
      find(".close", wait: 3).click
    end
  end

  expect(page).to have_no_css("#signInModal.show", visible: true, wait: 5)
end

Cuando("ingreso {string} en el campo {string} del modal de signup") do |value, field_name|
  field_id = SIGNUP_FIELD_IDS[field_name.downcase]
  raise "Campo desconocido: #{field_name}" unless field_id

  within("#signInModal") do
    find("##{field_id}", wait: 5).set(value)
  end
end

Cuando("hago clic en el botón {string} del modal de signup") do |button_text|
  within("#signInModal") do
    click_button(button_text)
  end
end

# -------------------------------------------------------------------
# When - Login
# -------------------------------------------------------------------
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

Cuando("ingreso {string} en el campo {string} del modal") do |value, field_name|
  field_id = LOGIN_FIELD_IDS[field_name.downcase]
  raise "Campo desconocido: #{field_name}" unless field_id

  within("#logInModal") do
    find("##{field_id}", wait: 5).set(value)
  end
end

Cuando("hago clic en el botón {string} del modal") do |button_text|
  within("#logInModal") do
    click_button(button_text)
  end
end

# -------------------------------------------------------------------
# Then
# -------------------------------------------------------------------
Entonces("debería ver {string} en el navbar") do |expected_text|
  expect(page).to have_css("#nameofuser", visible: true, wait: 10)
  expect(find("#nameofuser").text).to eq(expected_text)
end

Entonces("debería mostrar un mensaje de error") do
  sleep 2
  expect do
    page.driver.browser.switch_to.alert.accept
  end.not_to raise_error
end

Entonces("debería aparecer un alert con el mensaje {string}") do |expected_message|
  sleep 1
  expect(page.driver.browser.switch_to.alert.text).to eq(expected_message)
  page.driver.browser.switch_to.alert.accept
end
