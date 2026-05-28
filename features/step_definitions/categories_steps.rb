Cuando("selecciono la categoría {string}") do |category|
  @before_filter_count = all("#tbodyid .card", visible: true, wait: 10).size
  find("a.list-group-item", text: category).click
  sleep 1
end

Entonces("debería ver menos productos que en la página principal") do
  cards = all("#tbodyid .card", visible: true, wait: 10)
  expect(cards.size).to be < @before_filter_count
  expect(cards.size).to be > 0
end

Entonces("deberían aparecer todos los productos nuevamente") do
  cards = all("#tbodyid .card", visible: true, wait: 10)
  expect(cards.size).to eq(@before_filter_count)
end

Entonces("debería ver las categorías {string}, {string} y {string}") do |cat1, cat2, cat3|
  categories_text = all("a.list-group-item", wait: 5).map(&:text)
  expect(categories_text).to include(cat1, cat2, cat3)
end

Entonces("debería haber productos visibles después del filtro") do
  cards = all("#tbodyid .card", visible: true, wait: 10)
  expect(cards.size).to be > 0
end
