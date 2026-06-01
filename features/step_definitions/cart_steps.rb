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

    if defined?(@selected_product_name) && @selected_product_name
      expect(page).to have_content(@selected_product_name, wait: 10)
    end
  end
end

Cuando("realizo el pedido con:") do |table|
  @order_data = table.rows_hash

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

  within(".sweet-alert") do
    expect(page).to have_content("Thank you for your purchase!", wait: 5)
    expect(page).to have_content("Id:")
    expect(page).to have_content("Amount:")
  end
end

Cuando("elimino el producto del carrito") do
  @cart_items_before_delete = all("#tbodyid tr", wait: 10).count

  within("#tbodyid") do
    find("a", text: "Delete", wait: 10).click
  end
  sleep 1

  expect(all("#tbodyid tr", wait: 10).count).to eq(@cart_items_before_delete - 1)
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
    rows = all("tr", minimum: 1, wait: 10)

    rows.map do |row|
      row.all("td")[2].text.gsub(/\D/, "").to_i
    end
  end

  total = find("#totalp", wait: 5).text.gsub(/\D/, "").to_i

  expect(prices).not_to be_empty
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

    if defined?(@order_data) && @order_data
      expect(page).to have_content("Card Number: #{@order_data['credit card']}")
      expect(page).to have_content("Name: #{@order_data['name']}")
    end
  end
end

Cuando("cierro la confirmación de compra") do
  find(".confirm", wait: 10).click
  sleep 1
  expect(page).to have_no_css(".sweet-alert", visible: true, wait: 10)
end

Entonces("el carrito debería tener {int} productos en la lista") do |count|
  visible_product_names = within("#tbodyid") do
    rows = all("tr", count: count, wait: 10)

    rows.map do |row|
      row.all("td")[1].text
    end
  end

  if defined?(@selected_product_names) && @selected_product_names
    @selected_product_names.tally.each do |product_name, expected_count|
      expect(visible_product_names.tally[product_name]).to eq(expected_count)
    end
  end
end