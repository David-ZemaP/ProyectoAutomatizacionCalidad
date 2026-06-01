Cuando("completo el formulario de login con:") do |table|
  within("#logInModal") do
    form.fill_in_fields(table, DemoblazeConstants::LOGIN_FIELDS)
  end
end

Cuando("ingreso {string} en el campo {string} del modal") do |value, field_name|
  field_id = DemoblazeConstants::LOGIN_FIELD_IDS[field_name.downcase]
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

Entonces("no debería haber iniciado sesión") do
  begin
    page.driver.browser.switch_to.alert.accept
  rescue Selenium::WebDriver::Error::NoSuchAlertError
  end
  expect(page).to have_no_css("#nameofuser", visible: true, wait: 5)
end

Entonces("debería ver {string} en el navbar") do |expected_text|
  expect(page).to have_css("#nameofuser", visible: true, wait: 10)
  expect(find("#nameofuser").text).to eq(expected_text)
end

Entonces("el modal de login debería estar visible") do
  expect(page).to have_css("#logInModal.show", visible: true, wait: 5)
end

Cuando("cierro el modal de login con {string}") do |método|
  case método
  when "Close"
    within("#logInModal") do
      click_button("Close")
    end
  when "X"
    within("#logInModal") do
      find(".close", wait: 5).click
    end
  else
    raise "Método de cierre desconocido: #{método}"
  end
  sleep 0.5
  page.execute_script("$('#logInModal').modal('hide')")
end

Entonces("el modal de login debería estar cerrado") do
  expect(page).to have_no_css("#logInModal.show", visible: true, wait: 5)
end
