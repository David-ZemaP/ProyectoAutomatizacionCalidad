
LOGIN_FIELD_IDS = {
  "username" => "loginusername",
  "password" => "loginpassword"
}.freeze

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

Entonces("no debería haber iniciado sesión") do
  expect(page).to have_no_css("#nameofuser", visible: true, wait: 5)
end

Entonces("debería ver {string} en el navbar") do |expected_text|
  expect(page).to have_css("#nameofuser", visible: true, wait: 10)
  expect(find("#nameofuser").text).to eq(expected_text)
end
