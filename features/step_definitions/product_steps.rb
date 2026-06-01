def visible_catalog_product_names
  within("#tbodyid") do
    all(".card .card-title a", minimum: 1, wait: 10).map { |link| link.text.strip }
  end
end

def numeric_price(price_text)
  price_text.to_s.gsub(/[^\d]/, "").to_i
end

def expect_valid_product_price(price_text)
  expect(price_text).not_to be_empty
  expect(price_text).to start_with("$")
  expect(numeric_price(price_text)).to be > 0
end

Entonces("debería haber productos visibles en la página") do
  product_names = visible_catalog_product_names

  within("#tbodyid") do
    expect(page).to have_css(".card", minimum: 1, wait: 15)
  end

  expect(product_names).not_to be_empty
  expect(product_names.all? { |name| !name.empty? }).to be true

  if defined?(@product_names_before_pagination) && @product_names_before_pagination
    expect(product_names).not_to eq(@product_names_before_pagination)
    @product_names_before_pagination = nil
  end
end

Entonces("cada producto debería tener nombre y precio visible") do
  within("#tbodyid") do
    cards = all(".card", minimum: 1, wait: 10)

    cards.each do |card|
      product_name = card.find(".card-title a", wait: 2).text.strip
      price_text = card.find("h5", wait: 2).text.strip

      expect(product_name).not_to be_empty
      expect_valid_product_price(price_text)
    end
  end
end

def seleccionar_producto_por_indice(index)
  within("#tbodyid") do
    cards = all(".card", minimum: index + 1, wait: 10)
    product_card = cards[index]

    product = product_card.find(".hrefch", wait: 5)
    price = product_card.find("h5", wait: 5)

    @selected_product_name = product.text.strip
    @selected_product_price = price.text.strip
    @selected_product_names ||= []
    @selected_product_names << @selected_product_name

    expect(@selected_product_name).not_to be_empty
    expect_valid_product_price(@selected_product_price)

    product.click
  end
end

Cuando("hago clic en el primer producto de la lista") do
  seleccionar_producto_por_indice(0)
end

Cuando("hago clic en el segundo producto de la lista") do
  seleccionar_producto_por_indice(1)
end

Entonces("debería estar en la página de detalles del producto") do
  expect(page).to have_current_path(/prod\.html/, wait: 10)
  expect(page).to have_css("h2.name", wait: 10)
  expect(page).to have_css("h3.price-container", wait: 10)
  expect(page).to have_css(".btn-success", text: "Add to cart", wait: 10)

  detail_name = find("h2.name").text.strip
  detail_price = find("h3.price-container").text.strip

  expect(detail_name).not_to be_empty
  expect_valid_product_price(detail_price)

  if defined?(@selected_product_name) && @selected_product_name
    expect(detail_name).to eq(@selected_product_name)
  end

  if defined?(@selected_product_price) && @selected_product_price
    expect(numeric_price(detail_price)).to eq(numeric_price(@selected_product_price))
  end
end

Entonces("la página debería mostrar los datos del producto:") do |table|
  table.hashes.each do |row|
    case row["campo"]
    when "nombre"
      expect(page).to have_css("h2.name", wait: 5)
      product_name = find("h2.name").text.strip

      expect(product_name).not_to be_empty

      if defined?(@selected_product_name) && @selected_product_name
        expect(product_name).to eq(@selected_product_name)
      end
    when "precio"
      expect(page).to have_css("h3.price-container", wait: 5)
      price_text = find("h3.price-container").text.strip

      expect_valid_product_price(price_text)

      if defined?(@selected_product_price) && @selected_product_price
        expect(numeric_price(price_text)).to eq(numeric_price(@selected_product_price))
      end
    when "descripción"
      expect(page).to have_css("#more-information", wait: 5)
      description_text = find("#more-information").text.strip

      expect(description_text).not_to be_empty
      expect(description_text.length).to be > 10
    when "imagen"
      expect(page).to have_css("#imgp img", wait: 5)
      image = find("#imgp img", wait: 5)
      image_src = image["src"].to_s.strip

      expect(image_src).not_to be_empty
      expect(image_src).to match(%r{^https?://|/imgs/|imgs/})
      expect(image).to be_visible
    when "Add to cart"
      expect(page).to have_css(".btn-success", text: "Add to cart", wait: 5)
      expect(find(".btn-success", text: "Add to cart")).to be_visible
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
  expect(page).to have_css("#tbodyid .card", minimum: 1, wait: 10)
end

Cuando("hago clic en {string} de la paginación") do |button|
  @product_names_before_pagination = visible_catalog_product_names

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

Entonces("el precio debería comenzar con {string} y contener solo dígitos") do |expected_symbol|
  expect(page).to have_css("h3.price-container", wait: 10)

  price_text = find("h3.price-container").text.strip
  numeric_value = numeric_price(price_text)

  expect(price_text).to start_with(expected_symbol)
  expect(numeric_value).to be > 0
end

Entonces("cada producto debería tener una imagen visible") do
  within("#tbodyid") do
    cards = all(".card", minimum: 1, wait: 10)

    cards.each do |card|
      image = card.find("img[src]", wait: 2)
      image_src = image["src"].to_s.strip

      expect(image).to be_visible
      expect(image_src).not_to be_empty
      expect(image_src).to match(%r{^https?://|/imgs/|imgs/})
    end
  end
end

Cuando("recuerdo el nombre del primer producto en la lista") do
  within("#tbodyid") do
    product = first(".card .card-title a", wait: 10)
    @product_name = product.text.strip

    expect(@product_name).not_to be_empty
  end
end

Entonces("el nombre del producto en detalle debería coincidir") do
  expect(page).to have_css("h2.name", wait: 10)

  detail_name = find("h2.name").text.strip

  expect(detail_name).not_to be_empty
  expect(detail_name).to eq(@product_name)
end