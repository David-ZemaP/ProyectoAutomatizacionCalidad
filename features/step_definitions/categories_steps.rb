require 'json'
require 'net/http'
require 'uri'

def products_for_category(category)
  api_category = {
    'Phones' => 'phone',
    'Laptops' => 'notebook',
    'Monitors' => 'monitor'
  }[category]

  raise ArgumentError, "Categoría no soportada: #{category}" unless api_category

  uri = URI.parse('https://api.demoblaze.com/bycat')
  request = Net::HTTP::Post.new(uri)
  request['Content-Type'] = 'application/json'
  request.body = { cat: api_category }.to_json

  response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(request)
  end

  raise "Error consultando la API de categorías: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

  JSON.parse(response.body).fetch('Items', []).map { |item| item.fetch('title').to_s.strip }
end

Cuando("selecciono la categoría {string} para filtrar") do |category|
  @before_filter_count = all("#tbodyid .card", visible: true, wait: 10).size
  @expected_filter_titles = products_for_category(category)
  find("a.list-group-item", text: category).click
  sleep 1
end

Dado("que he seleccionado la categoría {string} para filtrar") do |category|
  @before_filter_count = all("#tbodyid .card", visible: true, wait: 10).size
  @expected_filter_titles = products_for_category(category)
  find("a.list-group-item", text: category).click
  sleep 1
end

Entonces("debería ver la lista de productos correspondiente a la categoría {string}") do |category|
  card_titles = visible_catalog_product_names
  expect(card_titles).to match_array(@expected_filter_titles)
end

Cuando("regreso a la página de inicio") do
  find(".navbar-brand", wait: 10).click
  sleep 1
end

Entonces("debería ver la lista completa de todos los productos disponibles") do
  cards = all("#tbodyid .card", visible: true, wait: 10)
  expect(cards.size).to eq(@before_filter_count)
end

Entonces("el menú lateral de categorías debería mostrar {string}, {string} y {string}") do |cat1, cat2, cat3|
  categories_text = all("a.list-group-item", wait: 5).map(&:text)
  expect(categories_text).to include(cat1, cat2, cat3)
end
