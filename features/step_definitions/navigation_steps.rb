def expect_home_page_loaded
  expect(page).to have_current_path(/\/|index\.html/, wait: 10)
  expect(page).to have_css("#navbarExample", visible: true, wait: 10)
  expect(page).to have_css("#tbodyid", visible: true, wait: 10)
  expect(page).to have_css("#tbodyid .card", minimum: 1, wait: 10)
  expect(page).to have_css("#cat", text: "CATEGORIES", wait: 10)
  expect(page).to have_css("a.list-group-item", text: "Phones", wait: 10)
  expect(page).to have_css("a.list-group-item", text: "Laptops", wait: 10)
  expect(page).to have_css("a.list-group-item", text: "Monitors", wait: 10)
end

def expect_contact_modal_loaded
  expect(page).to have_css("#exampleModal.show", visible: true, wait: 10)

  within("#exampleModal") do
    expect(page).to have_css(".modal-title", text: /New message/i, wait: 5)
    expect(page).to have_css("#recipient-email", visible: true, wait: 5)
    expect(page).to have_css("#recipient-name", visible: true, wait: 5)
    expect(page).to have_css("#message-text", visible: true, wait: 5)
    expect(page).to have_button("Send message", wait: 5)
    expect(page).to have_button("Close", wait: 5)
  end
end

def expect_about_modal_loaded
  expect(page).to have_css("#videoModal.show", visible: true, wait: 10)

  within("#videoModal") do
    expect(page).to have_css(".modal-title", text: /About us/i, wait: 5)
    expect(page).to have_css("#example-video", visible: :all, wait: 5)
    expect(page).to have_button("Close", wait: 5)
  end
end

def expect_cart_page_loaded
  expect(page).to have_current_path("/cart.html", wait: 10)
  expect(page).to have_css("#tbodyid", wait: 10)
  expect(page).to have_css("#page-wrapper", wait: 10)
  expect(page).to have_button("Place Order", wait: 10)

  expect(page).to have_css("#totalp", visible: :all, wait: 10)
end

Cuando("accedo a la sección {string} desde el menú de navegación") do |link_text|
  case link_text.downcase
  when "sign up"
    find(:xpath, DemoblazeConstants::SIGNUP_BUTTON).click
  when "log in"
    find(:xpath, DemoblazeConstants::LOGIN_BUTTON).click
  else
    click_link(link_text, match: :first)
  end
end

Entonces("la aplicación debería mostrar la sección {string}") do |resultado|
  case resultado
  when "principal"
    expect_home_page_loaded
  when "contacto"
    expect_contact_modal_loaded
  when "acerca_de"
    expect_about_modal_loaded
  when "carrito"
    expect_cart_page_loaded
  else
    raise "Resultado de navegación desconocido: #{resultado}"
  end
end

Cuando("abro la sección informativa Acerca de nosotros") do
  click_link("About us", match: :first)
  expect_about_modal_loaded
end

Cuando("cierro la ventana informativa usando el método {string}") do |metodo|
  within("#videoModal") do
    case metodo.downcase
    when "close"
      click_button("Close")
    when "x"
      find(".close", wait: 5).click
    else
      raise "Método de cierre desconocido: #{metodo}"
    end
  end
  sleep 0.5
  page.execute_script("$('#videoModal').modal('hide')") rescue nil
end

Entonces("la ventana informativa Acerca de nosotros debería cerrarse") do
  expect(page).to have_no_css("#videoModal.show", visible: true, wait: 5)
  expect(page).to have_no_css(".modal-backdrop", visible: true, wait: 5)
  expect(page).to have_css("#navbarExample", visible: true, wait: 5)
end