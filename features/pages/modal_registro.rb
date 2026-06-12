class ModalRegistro < PaginaBase
  MODAL_REGISTRO = "#signInModal"
  MODAL_REGISTRO_VISIBLE = "#signInModal.show"

  def validar_abierto
    esperar_css(MODAL_REGISTRO_VISIBLE)
  end

  def validar_cerrado
    esperar_no_css(MODAL_REGISTRO_VISIBLE)
    esperar_no_css(".modal-backdrop")
    expect(page).to have_xpath(DemoblazeConstants::SIGNUP_BUTTON, visible: true, wait: 5)
  end

  def registrar_usuario(usuario, password)
    within(MODAL_REGISTRO) do
      find("#sign-username", wait: 5).set(usuario)
      find("#sign-password", wait: 5).set(password)
      sleep 0.5
      click_button("Sign up")
    end
    sleep 1.5
  end

  def cerrar_con_boton(metodo)
    validar_abierto

    within(MODAL_REGISTRO_VISIBLE) do
      case metodo.strip.downcase
      when "close"
        click_button("Close")
      when "x"
        find(".modal-header .close", wait: 5).click
      else
        raise "Método de cierre desconocido: #{metodo}"
      end
    end

    sleep 0.5
    page.execute_script("$('#signInModal').modal('hide')") rescue nil
    validar_cerrado
  end

  def forzar_cierre
    if page.has_css?(MODAL_REGISTRO_VISIBLE, visible: true, wait: 2)
      page.execute_script("$('#signInModal').modal('hide')") rescue nil
    end
    validar_cerrado
  end

  def abrir_si_no_esta_abierto(componente_navbar)
    unless page.has_css?(MODAL_REGISTRO_VISIBLE, visible: true, wait: 2)
      componente_navbar.abrir_registro
      validar_abierto
    end
  end
end