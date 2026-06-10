def fill_and_submit_signup(username, password)
  unless page.has_css?("#signInModal.show", visible: true, wait: 2)
    find(:xpath, DemoblazeConstants::SIGNUP_BUTTON).click
    expect(page).to have_css("#signInModal.show", visible: true, wait: 5)
  end

  within("#signInModal") do
    find("#sign-username", wait: 5).set(username)
    find("#sign-password", wait: 5).set(password)
    sleep 0.5
    click_button("Sign up")
  end
  sleep 1.5
end

Cuando("me registro con el nuevo usuario {string} y la contraseña {string}") do |username, password|
  @saved_username = username
  fill_and_submit_signup(username, password)
  
  alert = wait_for_alert
  expect(alert.text).to eq("Sign up successful.")
  alert.accept

  if page.has_css?("#signInModal.show", visible: true, wait: 2)
    within("#signInModal") do
      find(".close", wait: 3).click
    end
  end
  expect(page).to have_no_css("#signInModal.show", visible: true, wait: 5)
end

Cuando("intento registrarme con el usuario {string} y la contraseña {string}") do |username, password|
  fill_and_submit_signup(username, password)
end

Cuando("intento registrarme con el usuario existente {string} y la contraseña {string}") do |username, password|
  fill_and_submit_signup(username, password)
end

Entonces("debería ver una advertencia de error de registro") do
  expect do
    alert = wait_for_alert
    alert.accept
  end.not_to raise_error
end

Cuando("abro el formulario de registro") do
  find(:xpath, DemoblazeConstants::SIGNUP_BUTTON).click
  expect(page).to have_css("#signInModal.show", visible: true, wait: 5)
end

Cuando("cierro el formulario de registro usando el método {string}") do |método|
  within("#signInModal") do
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
  page.execute_script("$('#signInModal').modal('hide')") rescue nil
end

Entonces("el formulario de registro debería cerrarse") do
  expect(page).to have_no_css("#signInModal.show", visible: true, wait: 5)
  expect(page).to have_no_css(".modal-backdrop", visible: true, wait: 5)
  expect(page).to have_xpath(DemoblazeConstants::SIGNUP_BUTTON, visible: true)
end