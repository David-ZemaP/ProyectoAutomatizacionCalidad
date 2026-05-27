Feature: Registro y validación de usuario en DemoBlaze
  Como usuario nuevo de DemoBlaze
  Quiero registrarme y luego iniciar sesión
  Para verificar que mi cuenta fue creada correctamente

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @smoke @positive @signup @first_run_only
  Scenario: Registro exitoso con validación mediante login
    When me registro con el usuario "qatest__12026" y contraseña "12026testerqa__"
    And hago clic en "Log in"
    And ingreso "qatest__12026" en el campo "Username" del modal
    And ingreso "12026testerqa__" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería ver "Welcome qatest__12026" en el navbar

  @negative @login
  Scenario: Login con contraseña incorrecta
    When hago clic en "Log in"
    And ingreso "qatest__12026" en el campo "Username" del modal
    And ingreso "WrongPassword99" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería mostrar un mensaje de error

  @negative @signup
  Scenario: Registro con usuario ya existente
    When hago clic en "Sign up"
    And ingreso "qatest__12026" en el campo "Username" del modal de signup
    And ingreso "12026testerqa__" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería aparecer un alert con el mensaje "This user already exist."
