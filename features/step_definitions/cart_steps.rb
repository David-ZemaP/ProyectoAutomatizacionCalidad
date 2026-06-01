Cuando("navego al carrito") do
  el = find("#cartur", wait: 10)
  page.execute_script("arguments[0].click()", el)
  expect(page).to have_current_path("/cart.html", wait: 10)
end

Entonces("el carrito debería estar vacío") do
  within("#tbodyid") do
    expect(page).to have_no_css("tr", wait: 10)
  end
end

Entonces("el carrito debería tener productos en la lista") do
  within("#tbodyid") do
    expect(page).to have_css("tr", minimum: 1, wait: 10)
  end
end

Cuando("realizo el pedido con:") do |table|
  click_button("Place Order")
  expect(page).to have_css("#orderModal.show", visible: true, wait: 10)

  within("#orderModal") do
    form.fill_in_fields(table, DemoblazeConstants::ORDER_FIELDS)
  end

  within("#orderModal") do
    click_button("Purchase")
  end
  sleep 2
end

Entonces("debería aparecer la confirmación de compra exitosa") do
  expect(page).to have_css(".sweet-alert", visible: true, wait: 10)
  expect(page).to have_content("Thank you for your purchase!", wait: 5)
end

Cuando("elimino el producto del carrito") do
  within("#tbodyid") do
    find("a", text: "Delete", wait: 10).click
  end
  sleep 1
end

Cuando("realizo el pedido vacío") do
  click_button("Place Order")
  expect(page).to have_css("#orderModal.show", visible: true, wait: 10)
  within("#orderModal") do
    click_button("Purchase")
  end
  sleep 1
end

Entonces("el total debería ser la suma de los productos") do
  prices = within("#tbodyid") do
    all("tr td:nth-child(3)").map { |td| td.text.gsub(/\D/, "").to_i }
  end
  total = find("#totalp", wait: 5).text.gsub(/\D/, "").to_i
  expect(total).to eq(prices.sum)
end

Entonces("la confirmación debería mostrar los detalles de la compra") do
  expect(page).to have_css(".sweet-alert", visible: true, wait: 10)
  within(".sweet-alert") do
    expect(page).to have_content("Thank you for your purchase!")
    expect(page).to have_content("Id:")
    expect(page).to have_content("Amount:")
    expect(page).to have_content("Card Number:")
    expect(page).to have_content("Name:")
    expect(page).to have_content("Date:")
  end
end

Cuando("cierro la confirmación de compra") do
  find(".confirm", wait: 10).click
  sleep 1
end

Entonces("el carrito debería tener {int} productos en la lista") do |count|
  within("#tbodyid") do
    expect(page).to have_css("tr", count: count, wait: 10)
  end
end
