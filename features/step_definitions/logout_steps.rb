Dado("que he iniciado sesión con el usuario {string} y la contraseña {string}") do |username, password|
  componente_navbar.abrir_login
  modal_login.validar_abierto
  modal_login.iniciar_sesion(username, password)
  componente_navbar.validar_usuario_logueado(username)
end

Cuando("cierro mi sesión de usuario") do
  componente_navbar.cerrar_sesion
end

Entonces("debería quedar desconectado de mi cuenta") do
  componente_navbar.validar_desconectado
end