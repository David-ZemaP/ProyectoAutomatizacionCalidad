Cuando("inicio sesión con el usuario {string} y la contraseña {string}") do |username, password|
  componente_navbar.abrir_login
  modal_login.validar_abierto
  modal_login.iniciar_sesion(username, password)
end

Entonces("debería ver el saludo de bienvenida para el usuario {string}") do |username|
  componente_navbar.validar_usuario_logueado(username)
end

Entonces("no debería ingresar a la cuenta") do
  aceptar_alerta if existe_alerta?
  componente_navbar.validar_desconectado
end

Cuando("abro el formulario de inicio de sesión") do
  componente_navbar.abrir_login
  modal_login.validar_abierto
end

Cuando("cierro el formulario usando el método {string}") do |método|
  modal_login.cerrar_con_boton(método)
end

Entonces("el formulario de inicio de sesión debería cerrarse") do
  modal_login.validar_cerrado
end