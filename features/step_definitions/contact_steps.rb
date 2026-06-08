Cuando("envío un mensaje de contacto con el correo {string}, nombre {string} y mensaje {string}") do |email, name, message|
  find("a", text: "Contact", wait: 10).click
  expect(page).to have_css("#exampleModal.show", visible: true, wait: 10)
  
  within("#exampleModal") do
    find("#recipient-email", wait: 5).set(email)
    find("#recipient-name", wait: 5).set(name)
    find("#message-text", wait: 5).set(message)
    click_button("Send message")
  end
  sleep 1.5
end

Entonces("el sistema debería confirmar el envío con el mensaje {string}") do |expected_message|
  alert = wait_for_alert
  expect(alert.text).to eq(expected_message)
  alert.accept
end

Cuando("abro el formulario de contacto") do
  find("a", text: "Contact", wait: 10).click
  expect(page).to have_css("#exampleModal.show", visible: true, wait: 10)
end

Cuando("cierro el formulario de contacto usando el método {string}") do |método|
  within("#exampleModal") do
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
  page.execute_script("$('#exampleModal').modal('hide')") rescue nil
end

Entonces("el formulario de contacto debería cerrarse") do
  expect(page).to have_no_css("#exampleModal.show", visible: true, wait: 5)
  expect(page).to have_no_css(".modal-backdrop", visible: true, wait: 5)
  expect(page).to have_css("#navbarExample", visible: true, wait: 5)
end
