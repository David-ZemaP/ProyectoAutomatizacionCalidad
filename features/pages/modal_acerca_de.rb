class ModalAcercaDe < PaginaBase
  def validar_abierto
    expect(page).to have_css("#videoModal.show", visible: true, wait: 10)
    within("#videoModal") do
      expect(page).to have_css(".modal-title", text: /About us/i, wait: 5)
      expect(page).to have_css("#example-video", visible: :all, wait: 5)
      expect(page).to have_button("Close", wait: 5)
    end
  end

  def validar_cerrado
    expect(page).to have_no_css("#videoModal.show", visible: true, wait: 5)
    expect(page).to have_no_css(".modal-backdrop", visible: true, wait: 5)
  end

  def cerrar_con_boton(metodo)
    within("#videoModal") do
      case metodo.downcase
      when "close"
        click_button("Close")
      when "x"
        find(".close", wait: 5).click
      else
        raise "Método de cierre desconocido: #{metodo}"
      end
    end
    sleep 0.5
    page.execute_script("$('#videoModal').modal('hide')") rescue nil
  end
end
