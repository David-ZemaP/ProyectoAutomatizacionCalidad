Feature: Cierre de sesión en DemoBlaze
  Como usuario de DemoBlaze
  Quiero cerrar sesión
  Para asegurarme de que mi sesión termina correctamente

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @positive @logout @smoke
  Scenario: Logout exitoso después de login exitoso
    When hago clic en "Log in"
    And ingreso "qatest__12026" en el campo "Username" del modal
    And ingreso "12026testerqa__" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería ver "Welcome qatest__12026" en el navbar
    When cierro sesión
    Then debería estar deslogueado
