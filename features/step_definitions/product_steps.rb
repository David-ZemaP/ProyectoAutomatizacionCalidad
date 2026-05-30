Entonces("debería haber productos visibles en la página") do
  within("#tbodyid") do
    expect(page).to have_css(".card", minimum: 1, wait: 15)
  end
end

Entonces("cada producto debería tener nombre y precio visible") do
  within("#tbodyid") do
    cards = all(".card", wait: 10)
    expect(cards.length).to be > 0

    cards.each do |card|
      expect(card).to have_css(".card-title", wait: 2)
      expect(card.text).to match(/\$\d+/)
    end
  end
end

Cuando("hago clic en el primer producto de la lista") do
  within("#tbodyid") do
    first(".card .hrefch", wait: 10).click
  end
end

Cuando("hago clic en el segundo producto de la lista") do
  within("#tbodyid") do
    all(".card .hrefch", wait: 10)[1].click
  end
end

Entonces("debería estar en la página de detalles del producto") do
  expect(page).to have_current_path(/prod\.html/, wait: 10)
  expect(page).to have_css("h2.name", wait: 10)
end

Entonces("la página debería mostrar los datos del producto:") do |table|
  table.hashes.each do |row|
    case row["campo"]
    when "nombre"
      expect(page).to have_css("h2.name", wait: 5)
      expect(find("h2.name").text).not_to be_empty
    when "precio"
      expect(page).to have_css("h3.price-container", wait: 5)
      expect(find("h3.price-container").text).not_to be_empty
    when "descripción"
      expect(page).to have_css("#more-information", wait: 5)
      expect(find("#more-information").text).not_to be_empty
    when "imagen"
      expect(page).to have_css("#imgp img", wait: 5)
      expect(find("#imgp img")["src"]).not_to be_empty
    when "Add to cart"
      expect(page).to have_css(".btn-success", text: "Add to cart", wait: 5)
    else
      raise "Campo desconocido en tabla: #{row['campo']}"
    end
  end
end

Cuando("vuelvo a la página de inicio") do
  find(".navbar-brand", wait: 10).click
end

Entonces("debería estar en la página principal") do
  expect(page).to have_current_path(/\/$|index\.html/, wait: 10)
  expect(page).to have_css("#tbodyid", wait: 10)
end

Cuando("hago clic en {string} de la paginación") do |button|
  case button.downcase
  when "next"
    find("#next2", wait: 10).click
    sleep 1
  when "previous"
    find("#prev2", wait: 10).click
    sleep 1
  else
    raise "Botón de paginación desconocido: #{button}"
  end
end

Entonces("el precio debería comenzar con {string} y contener solo dígitos") do |_arg|
  expect(page).to have_css("h3.price-container", wait: 10)
  price_text = find("h3.price-container").text

  expect(price_text).to start_with("$")
  numeric = price_text.gsub(/[$*.\s]/, "").gsub(/\D.*/, "")
  expect(numeric).to match(/^\d+$/)
end

Entonces("cada producto debería tener una imagen visible") do
  within("#tbodyid") do
    cards = all(".card", wait: 10)
    expect(cards.length).to be > 0

    cards.each do |card|
      expect(card).to have_css("img[src]", wait: 2)
      expect(card.find("img")["src"]).not_to be_empty
    end
  end
end

Cuando("recuerdo el nombre del primer producto en la lista") do
  within("#tbodyid") do
    @product_name = first(".card .card-title", wait: 10).text
  end
end

Entonces("el nombre del producto en detalle debería coincidir") do
  expect(page).to have_css("h2.name", wait: 10)
  expect(find("h2.name").text).to eq(@product_name)
end
