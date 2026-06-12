Cuando("envío un mensaje de contacto con el correo {string}, nombre {string} y mensaje {string}") do |email, name, message|
  componente_navbar.abrir_contacto
  modal_contacto.validar_abierto
  modal_contacto.enviar_mensaje(email, name, message)
end

Entonces("el sistema debería confirmar el envío con el mensaje {string}") do |expected_message|
  modal_contacto.validar_confirmacion_envio(expected_message)
end

Cuando("abro el formulario de contacto") do
  componente_navbar.abrir_contacto
  modal_contacto.validar_abierto
end

Cuando("cierro el formulario de contacto usando el método {string}") do |método|
  modal_contacto.cerrar_con_boton(método)
end

Entonces("el formulario de contacto debería cerrarse") do
  modal_contacto.validar_cerrado
end
