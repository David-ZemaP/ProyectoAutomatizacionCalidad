class ModalOrden < PaginaBase
  def validar_abierto
    esperar_css("#orderModal.show")
  end

  def llenar_datos_y_comprar(table, form_helper)
    within("#orderModal") do
      form_helper.fill_in_fields(table, DemoblazeConstants::ORDER_FIELDS)
      click_button("Purchase")
    end

    sleep 2 
  end

  def comprar_solo_con_nombre(nombre)
    within("#orderModal") do
      fill_in "name", with: nombre
      click_button("Purchase")
    end
  end

  def intentar_comprar_vacio
    within("#orderModal") do
      click_button("Purchase")
    end
  end

  def validar_mensaje_error(mensaje_esperado)
    validar_alerta(mensaje_esperado)
  end

  def validar_compra_exitosa
    esperar_css(".sweet-alert")
    within(".sweet-alert") do
      esperar_css("h2", text: "Thank you for your purchase!")
    end
  end

  def validar_detalles_compra(nombre, tarjeta)
    esperar_css(".sweet-alert")
    within(".sweet-alert") do
      expect(page).to have_content("Thank you for your purchase!")
      expect(page).to have_content("Card Number: #{tarjeta}")
      expect(page).to have_content("Name: #{nombre}")
    end
  end

  def cerrar_confirmacion
    click_seguro(".sweet-alert .confirm")
    sleep 1 
    esperar_no_css(".sweet-alert", visible: true, wait: 10)
  end
end
