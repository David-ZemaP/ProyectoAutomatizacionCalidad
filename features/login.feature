Feature: Validación de login en DemoBlaze
  Como usuario de DemoBlaze
  Quiero validar que el login maneja correctamente casos borde
  Para asegurar la robustez del formulario de inicio de sesión

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @smoke @positive @login
  Scenario: Login exitoso con credenciales válidas
    When hago clic en "Log in"
    And ingreso "qatest__12026" en el campo "Username" del modal
    And ingreso "12026testerqa__" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería ver "Welcome qatest__12026" en el navbar

  @negative @login @validation @empty
  Scenario Outline: Login con campos vacíos
    When hago clic en "Log in"
    And ingreso "<username>" en el campo "Username" del modal
    And ingreso "<password>" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería mostrar un mensaje de error
    And no debería haber iniciado sesión

    Examples:
      | username     | password     |
      |              | somepassword |
      | someuser     |              |
      |              |              |

  @negative @login @validation @injection
  Scenario Outline: Login con inyección en username
    When hago clic en "Log in"
    And ingreso "<username>" en el campo "Username" del modal
    And ingreso "password" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then no debería haber iniciado sesión

    Examples:
      | username                  |
      | ' OR 1=1 --               |
      | <script>alert(1)</script> |

  @negative @login @validation
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

  @negative @login @validation
  Scenario: Login con contraseña incorrecta
    When hago clic en "Log in"
    And ingreso "qatest__12026" en el campo "Username" del modal
    And ingreso "WrongPassword99" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería aparecer un alert con el mensaje "Wrong password."

  @negative @login @validation @boundary
  Scenario: Login con valores extremadamente largos
    When hago clic en "Log in"
    And ingreso "aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz" en el campo "Username" del modal
    And ingreso "password" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then no debería haber iniciado sesión

  @negative @login @ui
  Scenario Outline: Cerrar modal de login con <método>
    When hago clic en "Log in"
    Then el modal de login debería estar visible
    When cierro el modal de login con "<método>"
    Then el modal de login debería estar cerrado

    Examples:
      | método |
      | Close  |
      | X      |
