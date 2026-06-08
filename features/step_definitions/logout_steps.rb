Dado("que he iniciado sesión con el usuario {string} y la contraseña {string}") do |username, password|
  step "inicio sesión con el usuario \"#{username}\" y la contraseña \"#{password}\""
  step "debería ver el saludo de bienvenida para el usuario \"#{username}\""
end

Cuando("cierro mi sesión de usuario") do
  el = find("#logout2", wait: 10)
  page.execute_script("arguments[0].click()", el)
  sleep 1
end

Entonces("debería quedar desconectado de mi cuenta") do
  expect(page).to have_no_css("#nameofuser", visible: true, wait: 10)
  expect(page).to have_no_css("#logout2", visible: true, wait: 10)
  expect(page).to have_css("#login2", visible: true, wait: 10)
  expect(page).to have_css("#signin2", visible: true, wait: 10)
  expect(find("#login2").text).to eq("Log in")
  expect(find("#signin2").text).to eq("Sign up")
end