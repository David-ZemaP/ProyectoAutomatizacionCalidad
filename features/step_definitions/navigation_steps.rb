Cuando("accedo a la sección {string} desde el menú de navegación") do |link_text|
  componente_navbar.navegar_a_seccion(link_text)
end

Entonces("la aplicación debería mostrar la sección {string}") do |resultado|
  case resultado
  when "principal"
    pagina_inicio.validar_cargada
  when "contacto"
    modal_contacto.validar_abierto
  when "acerca_de"
    modal_acerca_de.validar_abierto
  when "carrito"
    pagina_carrito.validar_cargada
  else
    raise "Resultado de navegación desconocido: #{resultado}"
  end
end

Cuando("abro la sección informativa Acerca de nosotros") do
  componente_navbar.abrir_acerca_de
  modal_acerca_de.validar_abierto
end

Cuando("cierro la ventana informativa usando el método {string}") do |metodo|
  modal_acerca_de.cerrar_con_boton(metodo)
end

Entonces("la ventana informativa Acerca de nosotros debería cerrarse") do
  modal_acerca_de.validar_cerrado
end