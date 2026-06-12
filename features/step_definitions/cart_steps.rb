def agregar_producto_actual_al_carrito
  pagina_detalle_producto.agregar_al_carrito
  pagina_detalle_producto.validar_confirmacion_carrito
end

Dado("que tengo el producto {string} en mi carrito de compras") do |product_name|
  pagina_inicio.seleccionar_producto_por_nombre(product_name)
  agregar_producto_actual_al_carrito
  pagina_inicio.cargar
end

Dado("que he agregado los productos {string} y {string} al carrito") do |prod1, prod2|
  pagina_inicio.seleccionar_producto_por_nombre(prod1)
  agregar_producto_actual_al_carrito
  pagina_inicio.cargar
  pagina_inicio.seleccionar_producto_por_nombre(prod2)
  agregar_producto_actual_al_carrito
  pagina_inicio.cargar
end

Dado("que he agregado el producto {string} al carrito dos veces") do |product_name|
  2.times do
    pagina_inicio.seleccionar_producto_por_nombre(product_name)
    agregar_producto_actual_al_carrito
    pagina_inicio.cargar
  end
end

Cuando("accedo a mi carrito de compras") do
  componente_navbar.abrir_carrito
  pagina_carrito.validar_cargada
end

Entonces("el carrito de compras debería estar vacío") do
  pagina_carrito.validar_vacio
end

Cuando("agrego el producto seleccionado al carrito") do
  agregar_producto_actual_al_carrito
end

Entonces("el producto {string} debería figurar en mi carrito de compras") do |product_name|
  pagina_carrito.validar_producto_presente(product_name)
end

Cuando("realizo la compra con los siguientes datos del comprador:") do |table|
  @order_data = table.rows_hash
  
  pagina_carrito.asegurar_en_carrito(componente_navbar)
  
  pagina_carrito.ir_a_ordenar
  modal_orden.validar_abierto
  modal_orden.llenar_datos_y_comprar(table, form)
end

Entonces("la compra debería ser confirmada exitosamente") do
  modal_orden.validar_compra_exitosa
  modal_orden.cerrar_confirmacion
end

Cuando("elimino el producto {string} de la lista de compras") do |product_name|
  pagina_carrito.asegurar_en_carrito(componente_navbar)
  pagina_carrito.eliminar_producto(product_name)
end

Entonces("el precio total debería reflejar la suma de los precios de los productos seleccionados") do
  pagina_carrito.validar_precio_total
end

Entonces("el carrito de compras debería contener {int} productos") do |count|
  pagina_carrito.validar_cantidad_productos(count)
end

Cuando("intento realizar la compra dejando vacíos los campos obligatorios") do
  pagina_carrito.asegurar_en_carrito(componente_navbar)
  pagina_carrito.ir_a_ordenar
  modal_orden.validar_abierto
  modal_orden.intentar_comprar_vacio
end

Entonces("debería ver la advertencia de compra {string}") do |expected_message|
  modal_orden.validar_mensaje_error(expected_message)
end

Cuando("intento realizar la compra ingresando solo el nombre {string} sin tarjeta") do |name|
  pagina_carrito.asegurar_en_carrito(componente_navbar)
  pagina_carrito.ir_a_ordenar
  modal_orden.validar_abierto
  modal_orden.comprar_solo_con_nombre(name)
end

Entonces("la confirmación debería detallar la transacción para {string} y la tarjeta {string}") do |name, card|
  modal_orden.validar_detalles_compra(name, card)
end

Entonces("al cerrar la confirmación el carrito de compras debería quedar vacío") do
  modal_orden.cerrar_confirmacion
  pagina_carrito.validar_vacio_despues_de_compra
end