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

def seleccionar_producto_por_nombre(product_name)
  visit "/" unless page.has_css?("#tbodyid .card", wait: 5)
  within("#tbodyid") do
    find(".card-title a", text: product_name, wait: 10).click
  end
  expect(page).to have_current_path(/prod\.html/, wait: 10)
end

Entonces("debería ver productos disponibles en el catálogo") do
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

Entonces("cada producto listado debería mostrar su respectivo nombre y precio") do
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

Cuando("selecciono el producto {string}") do |product_name|
  @selected_product_name = product_name
  seleccionar_producto_por_nombre(product_name)
end

Dado("que estoy visualizando los detalles del producto {string}") do |product_name|
  @selected_product_name = product_name
  seleccionar_producto_por_nombre(product_name)
end

Entonces("debería ver la página de detalles del producto") do
  expect(page).to have_current_path(/prod\.html/, wait: 10)
  expect(page).to have_css("h2.name", wait: 10)
  expect(page).to have_css("h3.price-container", wait: 10)
  expect(page).to have_css(".btn-success", text: "Add to cart", wait: 10)
end

Entonces("los detalles deberían incluir nombre, precio, descripción e imagen del producto") do
  expect(page).to have_css("h2.name", wait: 5)
  expect(find("h2.name").text.strip).to eq(@selected_product_name) if @selected_product_name
  
  expect(page).to have_css("h3.price-container", wait: 5)
  price_text = find("h3.price-container").text.strip
  expect_valid_product_price(price_text)
  
  expect(page).to have_css("#more-information", wait: 5)
  expect(find("#more-information").text.strip.length).to be > 10
  
  expect(page).to have_css("#imgp img", wait: 5)
  image = find("#imgp img", wait: 5)
  expect(image["src"].to_s.strip).to match(%r{^https?://|/imgs/|imgs/})
  expect(image).to be_visible
end

Cuando("regreso al catálogo principal") do
  find(".navbar-brand", wait: 10).click
  sleep 1
end

Entonces("debería ver el catálogo de productos disponible nuevamente") do
  expect(page).to have_current_path(/\/$|index\.html/, wait: 10)
  expect(page).to have_css("#tbodyid", wait: 10)
  expect(page).to have_css("#tbodyid .card", minimum: 1, wait: 10)
end

Cuando("agrego el producto al carrito de compras") do
  click_link_or_button("Add to cart")
end

Entonces("la tienda debería confirmar la adición del producto") do
  alert = wait_for_alert
  expect(alert.text).to eq("Product added")
  alert.accept
end

Cuando("avanzo a la siguiente página del catálogo de productos") do
  @product_names_before_pagination = visible_catalog_product_names
  find("#next2", wait: 10).click
  sleep 1.5
end

Entonces("debería ver nuevos productos listados en la página") do
  step "debería ver productos disponibles en el catálogo"
end

Cuando("retrocedo a la página anterior del catálogo") do
  @product_names_before_pagination = visible_catalog_product_names
  find("#prev2", wait: 10).click
  sleep 1.5
end

Entonces("debería ver los productos iniciales listados en la página") do
  step "debería ver productos disponibles en el catálogo"
end

Entonces("el precio del producto debería comenzar con el símbolo {string} y contener solo dígitos numéricos") do |expected_symbol|
  expect(page).to have_css("h3.price-container", wait: 10)
  price_text = find("h3.price-container").text.strip
  expect(price_text).to start_with(expected_symbol)
  expect(numeric_price(price_text)).to be > 0
end

Entonces("el nombre visible en la página de detalles debería ser {string}") do |expected_name|
  expect(page).to have_css("h2.name", wait: 10)
  expect(find("h2.name").text.strip).to eq(expected_name)
end

Entonces("cada producto listado debería contar con una imagen visible") do
  within("#tbodyid") do
    cards = all(".card", minimum: 1, wait: 10)
    cards.each do |card|
      image = card.find("img[src]", wait: 2)
      expect(image).to be_visible
      expect(image["src"].to_s.strip).to match(%r{^https?://|/imgs/|imgs/})
    end
  end
end