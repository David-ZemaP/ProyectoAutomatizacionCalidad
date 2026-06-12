Cuando("selecciono la categoría {string} para filtrar") do |category|
  @before_filter_count = pagina_inicio.obtener_nombres_productos_visibles.size
  @expected_filter_titles = productos_por_categoria(category)
  pagina_inicio.seleccionar_categoria(category)
  pagina_inicio.esperar_productos_iguales_a(@expected_filter_titles)
end

Dado("que he seleccionado la categoría {string} para filtrar") do |category|
  @before_filter_count = pagina_inicio.obtener_nombres_productos_visibles.size
  @expected_filter_titles = productos_por_categoria(category)
  pagina_inicio.seleccionar_categoria(category)
  pagina_inicio.esperar_productos_iguales_a(@expected_filter_titles)
end

Entonces("debería ver la lista de productos correspondiente a la categoría {string}") do |category|
  card_titles = pagina_inicio.obtener_nombres_productos_visibles
  expect(card_titles).to match_array(@expected_filter_titles)
end

Cuando("regreso a la página de inicio") do
  componente_navbar.ir_a_inicio
  pagina_inicio.validar_cargada
end

Entonces("debería ver la lista completa de todos los productos disponibles") do
  cards_size = pagina_inicio.obtener_nombres_productos_visibles.size
  expect(cards_size).to eq(@before_filter_count)
end

Entonces("el menú lateral de categorías debería mostrar {string}, {string} y {string}") do |cat1, cat2, cat3|
  categories_text = pagina_inicio.obtener_categorias
  expect(categories_text).to include(cat1, cat2, cat3)
end
