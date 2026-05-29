Entonces("la navegación debería mostrar {string}") do |resultado|
  case resultado
  when "principal"
    expect(page).to have_current_path(/\/$|index\.html/, wait: 10)
  when "contacto"
    expect(page).to have_css("#exampleModal.show", visible: true, wait: 10)
  when "acerca_de"
    expect(page).to have_css("#videoModal.show", visible: true, wait: 10)
  when "carrito"
    expect(page).to have_current_path("/cart.html", wait: 10)
  else
    raise "Resultado de navegación desconocido: #{resultado}"
  end
end

Entonces("el modal About us debería estar visible") do
  expect(page).to have_css("#videoModal.show", visible: true, wait: 10)
end

Cuando("cierro el modal About us con {string}") do |metodo|
  within("#videoModal") do
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
  page.execute_script("$('#videoModal').modal('hide')")
end

Entonces("el modal About us debería estar cerrado") do
  expect(page).to have_no_css("#videoModal.show", visible: true, wait: 5)
end
