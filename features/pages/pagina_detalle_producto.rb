class PaginaDetalleProducto < PaginaBase
  def validar_cargada
    expect(page).to have_current_path(/prod\.html/, wait: 10)
    expect(page).to have_css("h2.name", wait: 10)
    expect(page).to have_css("h3.price-container", wait: 10)
    expect(page).to have_css(".btn-success", text: "Add to cart", wait: 10)
  end

  def validar_nombre(nombre_esperado)
    expect(page).to have_css("h2.name", wait: 10)
    expect(find("h2.name").text.strip).to eq(nombre_esperado)
  end

  def validar_precio_formato(simbolo)
    expect(page).to have_css("h3.price-container", wait: 10)
    price_text = find("h3.price-container").text.strip
    expect(price_text).to start_with(simbolo)
    expect(price_text.gsub(/[^\d]/, "").to_i).to be > 0
  end

  def validar_detalles_completos(nombre_esperado)
    expect(page).to have_css("h2.name", wait: 5)
    expect(find("h2.name").text.strip).to eq(nombre_esperado) if nombre_esperado
    
    expect(page).to have_css("h3.price-container", wait: 5)
    price_text = find("h3.price-container").text.strip
    expect(price_text).not_to be_empty
    expect(price_text).to start_with("$")
    expect(price_text.gsub(/[^\d]/, "").to_i).to be > 0
    
    expect(page).to have_css("#more-information", wait: 5)
    expect(find("#more-information").text.strip.length).to be > 10
    
    expect(page).to have_css("#imgp img", wait: 5)
    image = find("#imgp img", wait: 5)
    expect(image["src"].to_s.strip).to match(%r{^https?://|/imgs/|imgs/})
    expect(image).to be_visible
  end

  def agregar_al_carrito
    click_link_or_button("Add to cart")
  end

  def validar_confirmacion_carrito
    validar_alerta(DemoblazeConstants::MENSAJE_PRODUCTO_AGREGADO)
  end
end
