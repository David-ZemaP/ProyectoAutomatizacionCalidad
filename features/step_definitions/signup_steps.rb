def fill_and_submit_signup(username, password)
  modal_registro.abrir_si_no_esta_abierto(componente_navbar)
  modal_registro.registrar_usuario(username, password)
end

Cuando("me registro con el nuevo usuario {string} y la contraseña {string}") do |username, password|
  @saved_username = username
  fill_and_submit_signup(username, password)
  
  validar_alerta("Sign up successful.")

  modal_registro.forzar_cierre
  modal_registro.validar_cerrado
end

Cuando("intento registrarme con el usuario {string} y la contraseña {string}") do |username, password|
  fill_and_submit_signup(username, password)
end

Cuando("intento registrarme con el usuario existente {string} y la contraseña {string}") do |username, password|
  fill_and_submit_signup(username, password)
end

Entonces("debería ver una advertencia de error de registro") do
  expect do
    aceptar_alerta
  end.not_to raise_error
end

Cuando("abro el formulario de registro") do
  componente_navbar.abrir_registro
  modal_registro.validar_abierto
end

Cuando("cierro el formulario de registro usando el método {string}") do |método|
  modal_registro.cerrar_con_boton(método)
end

Entonces("el formulario de registro debería cerrarse") do
  modal_registro.validar_cerrado
end