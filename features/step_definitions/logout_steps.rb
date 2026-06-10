Dado("que he iniciado sesión con el usuario {string} y la contraseña {string}") do |username, password|
  step "inicio sesión con el usuario \"#{username}\" y la contraseña \"#{password}\""
  step "debería ver el saludo de bienvenida para el usuario \"#{username}\""
end

Cuando("cierro mi sesión de usuario") do
  el = find(:xpath, DemoblazeConstants::LOGOUT_BUTTON)
  page.execute_script("arguments[0].click()", el)
  sleep 1
end

Entonces("debería quedar desconectado de mi cuenta") do
  expect(page).to have_no_css("#nameofuser", visible: true, wait: 10)
  expect(page).to have_no_xpath(DemoblazeConstants::LOGOUT_BUTTON, visible: true)
  expect(page).to have_xpath(DemoblazeConstants::LOGIN_BUTTON, visible: true)
  expect(page).to have_xpath(DemoblazeConstants::SIGNUP_BUTTON, visible: true)
end