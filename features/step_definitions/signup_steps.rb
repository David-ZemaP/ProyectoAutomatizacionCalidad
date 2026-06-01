Cuando("me registro con:") do |table|
  credentials = table.rows_hash
  @saved_username = credentials.fetch("username")

  unless page.has_css?("#signInModal.show", visible: true, wait: 1)
    find("#signin2", wait: 10).click
    expect(page).to have_css("#signInModal.show", visible: true, wait: 5)
  end

  within("#signInModal") do
    form.fill_in_fields(table, DemoblazeConstants::SIGNUP_FIELDS)
    sleep 1
    click_button("Sign up")
  end

  sleep 2

  alert = wait_for_alert
  expect(alert.text).to eq("Sign up successful.")
  alert.accept

  if page.has_css?("#signInModal.show", visible: true, wait: 3)
    within("#signInModal") do
      find(".close", wait: 3).click
    end
  end

  expect(page).to have_no_css("#signInModal.show", visible: true, wait: 5)
end

Cuando("completo el formulario de signup con:") do |table|
  within("#signInModal") do
    form.fill_in_fields(table, DemoblazeConstants::SIGNUP_FIELDS)
  end
end

Cuando("ingreso {string} en el campo {string} del modal de signup") do |value, field_name|
  field_id = DemoblazeConstants::SIGNUP_FIELD_IDS[field_name.downcase]
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

Entonces("el modal de signup debería estar visible") do
  expect(page).to have_css("#signInModal.show", visible: true, wait: 5)

  within("#signInModal") do
    expect(page).to have_css(".modal-title", text: "Sign up", wait: 5)
    expect(page).to have_css("#sign-username", visible: true, wait: 5)
    expect(page).to have_css("#sign-password", visible: true, wait: 5)
    expect(page).to have_button("Sign up", wait: 5)
    expect(page).to have_button("Close", wait: 5)
  end
end

Cuando("cierro el modal de signup con {string}") do |método|
  case método
  when "Close"
    within("#signInModal") do
      click_button("Close")
    end
  when "X"
    within("#signInModal") do
      find(".close", wait: 5).click
    end
  else
    raise "Método de cierre desconocido: #{método}"
  end

  sleep 0.5
  page.execute_script("$('#signInModal').modal('hide')")
end

Entonces("el modal de signup debería estar cerrado") do
  expect(page).to have_no_css("#signInModal.show", visible: true, wait: 5)
  expect(page).to have_no_css(".modal-backdrop", visible: true, wait: 5)
  expect(page).to have_css("#signin2", visible: true, wait: 5)
end