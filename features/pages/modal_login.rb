class ModalLogin < PaginaBase
  def validar_abierto
    expect(page).to have_css("#logInModal.show", visible: true, wait: 5)
  end

  def validar_cerrado
    expect(page).to have_no_css("#logInModal.show", visible: true, wait: 5)
    expect(page).to have_no_css(".modal-backdrop", visible: true, wait: 5)
  end

  def iniciar_sesion(usuario, password)
    within("#logInModal") do
      find("#loginusername", wait: 5).set(usuario)
      find("#loginpassword", wait: 5).set(password)
      click_button("Log in")
    end
  end

  def cerrar_con_boton(metodo)
    within("#logInModal") do
      case metodo
      when "Close"
        click_button("Close")
      when "X"
        find(".close", wait: 5).click
      else
        raise "Método de cierre desconocido: #{metodo}"
      end
    end
    sleep 0.5
    page.execute_script("$('#logInModal').modal('hide')") rescue nil
  end
end
