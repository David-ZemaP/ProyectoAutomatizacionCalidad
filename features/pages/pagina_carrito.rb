class PaginaCarrito < PaginaBase
  def validar_cargada
    expect(page).to have_current_path(DemoblazeConstants::RUTA_CARRITO, wait: 10)
    esperar_css("#tbodyid")
    esperar_css("#page-wrapper")
    expect(page).to have_button("Place Order", wait: 10)
    esperar_css("#totalp", visible: :all)
  end

  def asegurar_en_carrito(componente_navbar)
    unless page.current_path == DemoblazeConstants::RUTA_CARRITO
      componente_navbar.abrir_carrito
    end
    validar_cargada
  end

  def validar_vacio
    expect(page).to have_css("#tbodyid", wait: 10)
    expect(page).to have_no_css("#tbodyid tr", wait: 10)
  end

  def validar_producto_presente(nombre_producto)
    within("#tbodyid") do
      expect(page).to have_content(nombre_producto, wait: 10)
    end
  end

  def validar_cantidad_productos(cantidad)
    within("#tbodyid") do
      esperar_css("tr", wait: 10) if cantidad > 0
      expect(page).to have_css("tr", count: cantidad, wait: 10)
    end
  end

  def eliminar_producto(nombre_producto)
    within("#tbodyid") do
      row = find("tr", text: nombre_producto, wait: 10)
      row.find("a", text: "Delete").click
    end
    esperar_no_css("tr", text: nombre_producto, wait: 10)
  end

  def validar_precio_total(timeout: 15)
    tiempo_inicio = Time.now
    ultimo_total_visible = nil
    ultima_suma_productos = nil

    loop do
      expect(page).to have_css("#tbodyid", wait: 10)
      expect(page).to have_css("#tbodyid tr", minimum: 1, wait: 10)

      filas = all("#tbodyid tr", wait: 5)

      ultima_suma_productos = filas.sum do |fila|
        columnas = fila.all("td")
        columnas[2].text.to_i
      end

      ultimo_total_visible = find("#totalp", wait: 5).text.to_i

      return true if ultimo_total_visible == ultima_suma_productos

      if Time.now - tiempo_inicio >= timeout
        raise "El total del carrito no coincide. Total visible: #{ultimo_total_visible}, suma de productos: #{ultima_suma_productos}"
      end

      sleep 0.5
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      retry if Time.now - tiempo_inicio < timeout

      raise "No se pudo validar el total porque la tabla del carrito se actualizó constantemente."
    end
  end

  def ir_a_ordenar
    click_button("Place Order")
  end

  def validar_vacio_despues_de_compra
    start_time = Time.now

    loop do
      visit DemoblazeConstants::RUTA_CARRITO
      expect(page).to have_css("#tbodyid", wait: 10)

      return if page.all("#tbodyid tr", wait: 2).empty?

      raise "El carrito no quedó vacío después de la compra" if Time.now - start_time > 10

      sleep 0.5
    end
  end
end
