Feature: Validación de login en DemoBlaze
  Como usuario de DemoBlaze
  Quiero validar que el login maneja correctamente casos borde
  Para asegurar la robustez del formulario de inicio de sesión

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @negative @login @validation @empty
  Scenario: Login con username vacío
    When hago clic en "Log in"
    And ingreso "" en el campo "Username" del modal
    And ingreso "somepassword" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería mostrar un mensaje de error
    And no debería haber iniciado sesión

  @negative @login @validation @empty
  Scenario: Login con password vacío
    When hago clic en "Log in"
    And ingreso "someuser" en el campo "Username" del modal
    And ingreso "" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería mostrar un mensaje de error
    And no debería haber iniciado sesión

  @negative @login @validation @empty
  Scenario: Login con ambos campos vacíos
    When hago clic en "Log in"
    And ingreso "" en el campo "Username" del modal
    And ingreso "" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería mostrar un mensaje de error
    And no debería haber iniciado sesión

  @negative @login @validation @injection
  Scenario: Login con caracteres especiales tipo SQL injection en username
    When hago clic en "Log in"
    And ingreso "' OR 1=1 --" en el campo "Username" del modal
    And ingreso "password" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then no debería haber iniciado sesión

  @negative @login @validation @injection
  Scenario: Login con intento de XSS en username
    When hago clic en "Log in"
    And ingreso "<script>alert(1)</script>" en el campo "Username" del modal
    And ingreso "password" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then no debería haber iniciado sesión

  @negative @login @validation @injection
  Scenario: Login con caracteres especiales en password
    When hago clic en "Log in"
    And ingreso "qatest__12026" en el campo "Username" del modal
    And ingreso "<>!@#$%^&*()" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería mostrar un mensaje de error
    And no debería haber iniciado sesión

  @negative @login @validation
  Scenario: Login con usuario que no existe
    When hago clic en "Log in"
    And ingreso "usuario_inexistente_12345" en el campo "Username" del modal
    And ingreso "password123" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería mostrar un mensaje de error
    And no debería haber iniciado sesión

  @negative @login @validation @boundary
  Scenario: Login con valores extremadamente largos
    When hago clic en "Log in"
    And ingreso "aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz" en el campo "Username" del modal
    And ingreso "password" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then no debería haber iniciado sesión
