class ModalContacto < PaginaBase
  def validar_abierto
    esperar_css("#exampleModal.show")
    within("#exampleModal") do
      esperar_css(".modal-title", text: /New message/i)
      esperar_css("#recipient-email")
      esperar_css("#recipient-name")
      esperar_css("#message-text")
      expect(page).to have_button("Send message", wait: 5)
      expect(page).to have_button("Close", wait: 5)
    end
  end

  def validar_cerrado
    esperar_no_css("#exampleModal.show")
    esperar_no_css(".modal-backdrop")
  end

  def enviar_mensaje(email, nombre, mensaje)
    within("#exampleModal") do
      find("#recipient-email", wait: 5).set(email)
      find("#recipient-name", wait: 5).set(nombre)
      find("#message-text", wait: 5).set(mensaje)
      click_button("Send message")
    end
  end

  def validar_confirmacion_envio(mensaje_esperado)
    validar_alerta(mensaje_esperado)
  end

  def cerrar_con_boton(metodo)
    within("#exampleModal") do
      case metodo
      when "Close"
        click_button("Close")
      when "X"
        click_seguro(".close")
      else
        raise "Método de cierre desconocido: #{metodo}"
      end
    end
    esperar_no_css(".modal-backdrop")
    page.execute_script("$('#exampleModal').modal('hide')") rescue nil
  end
end
