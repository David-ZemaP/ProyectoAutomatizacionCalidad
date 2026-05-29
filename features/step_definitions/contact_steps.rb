CONTACT_FIELD_IDS = {
  "contact email" => "recipient-email",
  "contact name" => "recipient-name",
  "message" => "message-text"
}.freeze

Entonces("el modal de contacto debería estar visible") do
  expect(page).to have_css("#exampleModal.show", visible: true, wait: 10)
end

Cuando("ingreso {string} en el campo {string} del modal de contacto") do |value, field_name|
  field_id = CONTACT_FIELD_IDS[field_name.downcase]
  raise "Campo de contacto desconocido: #{field_name}" unless field_id

  within("#exampleModal") do
    find("##{field_id}", wait: 5).set(value)
  end
end

Cuando("hago clic en {string} en el modal de contacto") do |button_text|
  within("#exampleModal") do
    click_button(button_text)
  end
  sleep 1
end

Cuando("cierro el modal de contacto con {string}") do |metodo|
  within("#exampleModal") do
    case metodo.downcase
    when "close"
      click_button("Close")
    when "x"
      find(".close", wait: 5).click
    else
      raise "Metodo de cierre desconocido: #{metodo}"
    end
  end
  sleep 0.5
  page.execute_script("$('#exampleModal').modal('hide')")
end

Entonces("el modal de contacto debería estar cerrado") do
  expect(page).to have_no_css("#exampleModal.show", visible: true, wait: 5)
end
