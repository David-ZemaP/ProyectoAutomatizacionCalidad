def agregar_producto_actual_al_carrito
  click_link_or_button("Add to cart")
  alert = wait_for_alert
  expect(alert.text).to eq("Product added")
  alert.accept
end

Dado("que tengo el producto {string} en mi carrito de compras") do |product_name|
  seleccionar_producto_por_nombre(product_name)
  agregar_producto_actual_al_carrito
  visit "/"
end

Dado("que he agregado los productos {string} y {string} al carrito") do |prod1, prod2|
  seleccionar_producto_por_nombre(prod1)
  agregar_producto_actual_al_carrito
  visit "/"
  seleccionar_producto_por_nombre(prod2)
  agregar_producto_actual_al_carrito
  visit "/"
end

Dado("que he agregado el producto {string} al carrito dos veces") do |product_name|
  2.times do
    seleccionar_producto_por_nombre(product_name)
    agregar_producto_actual_al_carrito
    visit "/"
  end
end

Cuando("accedo a mi carrito de compras") do
  find("#cartur", wait: 10).click
  expect(page).to have_current_path("/cart.html", wait: 10)
end

Entonces("el carrito de compras debería estar vacío") do
  within("#tbodyid") do
    expect(page).to have_no_css("tr", wait: 10)
  end
end



Cuando("agrego el producto seleccionado al carrito") do
  agregar_producto_actual_al_carrito
end

Entonces("el producto {string} debería figurar en mi carrito de compras") do |product_name|
  within("#tbodyid") do
    expect(page).to have_content(product_name, wait: 10)
  end
end

Cuando("realizo la compra con los siguientes datos del comprador:") do |table|
  @order_data = table.rows_hash
  
  unless page.current_path == "/cart.html"
    find("#cartur", wait: 10).click
  end
  
  click_button("Place Order")
  expect(page).to have_css("#orderModal.show", visible: true, wait: 10)

  within("#orderModal") do
    form.fill_in_fields(table, DemoblazeConstants::ORDER_FIELDS)
    click_button("Purchase")
  end
  sleep 2
end

Entonces("la compra debería ser confirmada exitosamente") do
  expect(page).to have_css(".sweet-alert", visible: true, wait: 10)
  within(".sweet-alert") do
    expect(page).to have_content("Thank you for your purchase!", wait: 5)
  end
  find(".confirm", wait: 10).click
end

Cuando("elimino el producto {string} de la lista de compras") do |product_name|
  unless page.current_path == "/cart.html"
    find("#cartur", wait: 10).click
  end

  within("#tbodyid") do
    row = find("tr", text: product_name, wait: 10)
    row.find("a", text: "Delete").click
  end
  sleep 1
end

Entonces("el precio total debería reflejar la suma de los precios de los productos seleccionados") do
  prices = within("#tbodyid") do
    rows = all("tr", minimum: 1, wait: 10)
    rows.map do |row|
      row.all("td")[2].text.gsub(/\D/, "").to_i
    end
  end

  total = find("#totalp", wait: 5).text.gsub(/\D/, "").to_i
  expect(prices).not_to be_empty
  expect(total).to eq(prices.sum)
end

Entonces("el carrito de compras debería contener {int} productos") do |count|
  within("#tbodyid") do
    expect(page).to have_css("tr", count: count, wait: 10)
  end
end

Cuando("intento realizar la compra dejando vacíos los campos obligatorios") do
  unless page.current_path == "/cart.html"
    find("#cartur", wait: 10).click
  end
  click_button("Place Order")
  expect(page).to have_css("#orderModal.show", visible: true, wait: 10)
  within("#orderModal") do
    click_button("Purchase")
  end
  sleep 1
end

Entonces("debería ver la advertencia de compra {string}") do |expected_message|
  alert = wait_for_alert
  expect(alert.text).to eq(expected_message)
  alert.accept
end

Cuando("intento realizar la compra ingresando solo el nombre {string} sin tarjeta") do |name|
  unless page.current_path == "/cart.html"
    find("#cartur", wait: 10).click
  end
  click_button("Place Order")
  expect(page).to have_css("#orderModal.show", visible: true, wait: 10)
  within("#orderModal") do
    fill_in "name", with: name
    click_button("Purchase")
  end
  sleep 1
end

Entonces("la confirmación debería detallar la transacción para {string} y la tarjeta {string}") do |name, card|
  expect(page).to have_css(".sweet-alert", visible: true, wait: 10)
  within(".sweet-alert") do
    expect(page).to have_content("Thank you for your purchase!")
    expect(page).to have_content("Card Number: #{card}")
    expect(page).to have_content("Name: #{name}")
  end
end

Entonces("al cerrar la confirmación el carrito de compras debería quedar vacío") do
  find(".confirm", wait: 10).click
  sleep 1
  expect(page).to have_no_css(".sweet-alert", visible: true, wait: 10)
  
  within("#tbodyid") do
    expect(page).to have_no_css("tr", wait: 10)
  end
end