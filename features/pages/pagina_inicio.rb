class PaginaInicio < PaginaBase
  SELECTOR_CONTENEDOR_CATALOGO = "#tbodyid"
  SELECTOR_TARJETAS_PRODUCTOS = "#tbodyid .card"
  SELECTOR_NOMBRES_PRODUCTOS = "#tbodyid .card-title a"
  SELECTOR_CATEGORIAS = "a.list-group-item"
  SELECTOR_BOTON_SIGUIENTE = "#next2"
  SELECTOR_BOTON_ANTERIOR = "#prev2"
  SELECTOR_NAVBAR = "#navbarExample"

  def cargar
    visit DemoblazeConstants::RUTA_INICIO
  end

  def validar_cargada
    expect(page).to have_current_path(/\/|index\.html/, wait: 10)
    validar_navbar_visible
    validar_catalogo_visible
    validar_categorias_visibles
  end

  def validar_navbar_visible
    esperar_css(SELECTOR_NAVBAR)
  end

  def validar_catalogo_visible
    esperar_css(SELECTOR_CONTENEDOR_CATALOGO)
    esperar_css(SELECTOR_TARJETAS_PRODUCTOS, minimum: 1)
    obtener_nombres_productos_visibles
  end

  def validar_categorias_visibles
    esperar_css("#cat", text: "CATEGORIES")
    esperar_css(SELECTOR_CATEGORIAS, text: "Phones")
    esperar_css(SELECTOR_CATEGORIAS, text: "Laptops")
    esperar_css(SELECTOR_CATEGORIAS, text: "Monitors")
  end

  def seleccionar_categoria(categoria)
    con_reintento_por_dom_inestable do
      find(SELECTOR_CATEGORIAS, text: categoria, wait: 10).click
    end
  end

  def seleccionar_producto_por_nombre(nombre_producto)
    cargar unless page.has_css?(SELECTOR_NOMBRES_PRODUCTOS, wait: 5)

    con_reintento_por_dom_inestable do
      esperar_css(SELECTOR_NOMBRES_PRODUCTOS, minimum: 1, wait: 10)

      producto = find(
        SELECTOR_NOMBRES_PRODUCTOS,
        text: nombre_producto,
        wait: 10,
        match: :first
      )

      page.execute_script("arguments[0].scrollIntoView({ block: 'center' });", producto)
      producto.click
    end
  end

  def obtener_nombres_productos_visibles(timeout: 10)
    tiempo_inicio = Time.now
    nombres_anteriores = nil

    loop do
      esperar_css(SELECTOR_CONTENEDOR_CATALOGO, wait: 10)

      nombres_actuales = nombres_productos_por_javascript

      if nombres_actuales.any?
        return nombres_actuales if nombres_actuales == nombres_anteriores

        nombres_anteriores = nombres_actuales
      end

      if Time.now - tiempo_inicio >= timeout
        raise "No se pudieron obtener productos visibles del catálogo"
      end

      sleep 0.25
    end
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry if Time.now - tiempo_inicio < timeout

    raise "No se pudieron obtener productos visibles porque el catálogo se actualizó constantemente"
  end

  def validar_productos_disponibles
    nombres = obtener_nombres_productos_visibles

    expect(nombres).not_to be_empty
    expect(nombres.all? { |nombre| !nombre.to_s.strip.empty? }).to be true
  end

  def validar_productos_con_nombre_y_precio
    productos = datos_productos_por_javascript

    expect(productos).not_to be_empty

    productos.each do |producto|
      nombre = producto["nombre"].to_s.strip
      precio = producto["precio"].to_s.strip

      expect(nombre).not_to be_empty
      expect(precio).not_to be_empty
      expect(precio).to start_with("$")
      expect(precio.gsub(/[^\d]/, "").to_i).to be > 0
    end
  end

  def validar_productos_con_imagen_visible
    productos = datos_imagenes_por_javascript

    expect(productos).not_to be_empty

    productos.each do |producto|
      src = producto["src"].to_s.strip
      visible = producto["visible"]

      expect(src).not_to be_empty
      expect(src).to match(%r{^https?://|/imgs/|imgs/})
      expect(visible).to eq(true)
    end
  end

  def esperar_productos_distintos_a(productos_anteriores, timeout: 15)
    tiempo_inicio = Time.now
    productos_anteriores = normalizar_lista_productos(productos_anteriores)

    loop do
      productos_actuales = normalizar_lista_productos(obtener_nombres_productos_visibles)

      return true if productos_actuales.any? && productos_actuales != productos_anteriores

      if Time.now - tiempo_inicio >= timeout
        raise "Los productos no cambiaron después de paginar. Productos anteriores: #{productos_anteriores}, productos actuales: #{productos_actuales}"
      end

      sleep 0.5
    end
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry if Time.now - tiempo_inicio < timeout

    raise "No se pudo validar el cambio de productos porque el catálogo se actualizó constantemente"
  end

  def esperar_productos_iguales_a(productos_esperados, timeout: 15)
    tiempo_inicio = Time.now
    productos_esperados = normalizar_lista_productos(productos_esperados)

    loop do
      productos_actuales = normalizar_lista_productos(obtener_nombres_productos_visibles)

      return true if productos_actuales.sort == productos_esperados.sort

      if Time.now - tiempo_inicio >= timeout
        raise "Los productos no coinciden. Esperados: #{productos_esperados}, actuales: #{productos_actuales}"
      end

      sleep 0.5
    end
  rescue Selenium::WebDriver::Error::StaleElementReferenceError
    retry if Time.now - tiempo_inicio < timeout

    raise "No se pudo validar la lista de productos porque el catálogo se actualizó constantemente"
  end

  def avanzar_pagina
    con_reintento_por_dom_inestable do
      click_seguro(SELECTOR_BOTON_SIGUIENTE)
    end
  end

  def retroceder_pagina
    con_reintento_por_dom_inestable do
      click_seguro(SELECTOR_BOTON_ANTERIOR)
    end
  end

  def validar_paginacion_disponible
    esperar_css(SELECTOR_BOTON_SIGUIENTE)
  end

  def obtener_categorias
    page.evaluate_script(<<~JS)
      Array.from(document.querySelectorAll('#{SELECTOR_CATEGORIAS}'))
        .map(function(categoria) {
          return categoria.textContent.trim();
        })
        .filter(function(texto) {
          return texto.length > 0;
        });
    JS
  end

  private

  def nombres_productos_por_javascript
    page.evaluate_script(<<~JS)
      Array.from(document.querySelectorAll('#{SELECTOR_NOMBRES_PRODUCTOS}'))
        .map(function(producto) {
          return producto.textContent.trim();
        })
        .filter(function(nombre) {
          return nombre.length > 0;
        });
    JS
  end

  def datos_productos_por_javascript
    esperar_css(SELECTOR_TARJETAS_PRODUCTOS, minimum: 1, wait: 10)

    page.evaluate_script(<<~JS)
      Array.from(document.querySelectorAll('#{SELECTOR_TARJETAS_PRODUCTOS}'))
        .map(function(card) {
          var nombre = card.querySelector('.card-title a');
          var precio = card.querySelector('h5');

          return {
            nombre: nombre ? nombre.textContent.trim() : '',
            precio: precio ? precio.textContent.trim() : ''
          };
        });
    JS
  end

  def datos_imagenes_por_javascript
    esperar_css(SELECTOR_TARJETAS_PRODUCTOS, minimum: 1, wait: 10)

    page.evaluate_script(<<~JS)
      Array.from(document.querySelectorAll('#{SELECTOR_TARJETAS_PRODUCTOS}'))
        .map(function(card) {
          var imagen = card.querySelector('img[src]');

          return {
            src: imagen ? imagen.getAttribute('src') : '',
            visible: imagen ? !!(imagen.offsetWidth || imagen.offsetHeight || imagen.getClientRects().length) : false
          };
        });
    JS
  end

  def normalizar_lista_productos(productos)
    Array(productos).map { |producto| producto.to_s.strip }.reject(&:empty?)
  end

  def con_reintento_por_dom_inestable(timeout: 10)
    tiempo_inicio = Time.now

    begin
      yield
    rescue Selenium::WebDriver::Error::StaleElementReferenceError
      raise if Time.now - tiempo_inicio >= timeout

      sleep 0.5
      retry
    end
  end
end