Entonces("debería ver productos disponibles en el catálogo") do
  pagina_inicio.validar_catalogo_visible
  pagina_inicio.validar_productos_disponibles

  if defined?(@product_names_before_pagination) && @product_names_before_pagination
    pagina_inicio.esperar_productos_distintos_a(@product_names_before_pagination)
    @product_names_before_pagination = nil
  end
end

Entonces("cada producto listado debería mostrar su respectivo nombre y precio") do
  pagina_inicio.validar_productos_con_nombre_y_precio
end

Cuando("selecciono el producto {string}") do |product_name|
  @selected_product_name = product_name
  pagina_inicio.seleccionar_producto_por_nombre(product_name)
end

Dado("que estoy visualizando los detalles del producto {string}") do |product_name|
  @selected_product_name = product_name
  pagina_inicio.seleccionar_producto_por_nombre(product_name)
end

Entonces("debería ver la página de detalles del producto") do
  pagina_detalle_producto.validar_cargada
end

Entonces("los detalles deberían incluir nombre, precio, descripción e imagen del producto") do
  pagina_detalle_producto.validar_detalles_completos(@selected_product_name)
end

Cuando("regreso al catálogo principal") do
  componente_navbar.ir_a_inicio
  pagina_inicio.validar_cargada
end

Entonces("debería ver el catálogo de productos disponible nuevamente") do
  pagina_inicio.validar_cargada
end

Cuando("agrego el producto al carrito de compras") do
  pagina_detalle_producto.agregar_al_carrito
end

Entonces("la tienda debería confirmar la adición del producto") do
  pagina_detalle_producto.validar_confirmacion_carrito
end

Cuando("avanzo a la siguiente página del catálogo de productos") do
  @product_names_before_pagination = pagina_inicio.obtener_nombres_productos_visibles
  pagina_inicio.avanzar_pagina
end

Entonces("debería ver nuevos productos listados en la página") do
  pagina_inicio.validar_catalogo_visible
  pagina_inicio.validar_productos_disponibles
  pagina_inicio.esperar_productos_distintos_a(@product_names_before_pagination) if @product_names_before_pagination
  @product_names_before_pagination = nil
end

Cuando("retrocedo a la página anterior del catálogo") do
  @product_names_before_pagination = pagina_inicio.obtener_nombres_productos_visibles
  pagina_inicio.retroceder_pagina
end

Entonces("debería ver los productos iniciales listados en la página") do
  pagina_inicio.validar_catalogo_visible
  pagina_inicio.validar_productos_disponibles
  pagina_inicio.esperar_productos_distintos_a(@product_names_before_pagination) if @product_names_before_pagination
  @product_names_before_pagination = nil
end

Entonces("el precio del producto debería comenzar con el símbolo {string} y contener solo dígitos numéricos") do |expected_symbol|
  pagina_detalle_producto.validar_precio_formato(expected_symbol)
end

Entonces("el nombre visible en la página de detalles debería ser {string}") do |expected_name|
  pagina_detalle_producto.validar_nombre(expected_name)
end

Entonces("cada producto listado debería contar con una imagen visible") do
  pagina_inicio.validar_productos_con_imagen_visible
end