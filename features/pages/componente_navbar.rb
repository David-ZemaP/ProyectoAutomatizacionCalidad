class ComponenteNavbar < PaginaBase
  def abrir_login
    click_seguro(:xpath, DemoblazeConstants::LOGIN_BUTTON)
  end

  def abrir_registro
    click_seguro(:xpath, DemoblazeConstants::SIGNUP_BUTTON)
  end

  def abrir_carrito
    click_seguro("#cartur")
  end

  def abrir_contacto
    click_seguro("a", text: "Contact")
  end

  def abrir_acerca_de
    click_link("About us", match: :first)
  end

  def ir_a_inicio
    click_seguro(".navbar-brand")
  end

  def cerrar_sesion
    el = find(:xpath, DemoblazeConstants::LOGOUT_BUTTON)
    page.execute_script("arguments[0].click()", el)
  end

  def validar_usuario_logueado(username)
    esperar_css("#nameofuser", wait: 15)
    expect(texto_de("#nameofuser")).to eq("Welcome #{username}")
    esperar_css(:xpath, DemoblazeConstants::LOGOUT_BUTTON)
    esperar_no_css(:xpath, DemoblazeConstants::LOGIN_BUTTON)
    esperar_no_css(:xpath, DemoblazeConstants::SIGNUP_BUTTON)
  end

  def validar_desconectado
    esperar_no_css("#nameofuser")
    esperar_no_css(:xpath, DemoblazeConstants::LOGOUT_BUTTON)
    esperar_css(:xpath, DemoblazeConstants::LOGIN_BUTTON)
    esperar_css(:xpath, DemoblazeConstants::SIGNUP_BUTTON)
  end

  def navegar_a_seccion(link_text)
    case link_text.downcase
    when "sign up"
      abrir_registro
    when "log in"
      abrir_login
    else
      click_link(link_text, match: :first)
    end
  end

  def cantidad_carrito
    cart_text = texto_de("#cartur", wait: 3)
    if cart_text.match?(/\((\d+)\)/)
      cart_text.match(/\((\d+)\)/)[1].to_i
    else
      0
    end
  rescue Capybara::ElementNotFound
    0
  end
end
