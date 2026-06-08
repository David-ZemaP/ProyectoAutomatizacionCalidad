Feature: Cierre de sesión en DemoBlaze
  Como usuario de DemoBlaze
  Quiero cerrar sesión
  Para asegurarme de que mi sesión termina correctamente

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @positive @logout @smoke
  Scenario: Logout exitoso después de login exitoso
    Given que he iniciado sesión con el usuario "qatest__12026" y la contraseña "12026testerqa__"
    When cierro mi sesión de usuario
    Then debería quedar desconectado de mi cuenta
