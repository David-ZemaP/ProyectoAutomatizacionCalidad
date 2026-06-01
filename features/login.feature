Feature: Validación de login en DemoBlaze
  Como usuario de DemoBlaze
  Quiero validar que el login maneja correctamente casos borde
  Para asegurar la robustez del formulario de inicio de sesión

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @smoke @positive @login
  Scenario: Login exitoso con credenciales válidas
    When hago clic en "Log in"
    And completo el formulario de login con:
      | username | qatest__12026 |
      | password | 12026testerqa__ |
    And hago clic en el botón "Log in" del modal
    Then debería ver "Welcome qatest__12026" en el navbar

  @negative @login @validation @empty
  Scenario Outline: Login con campos vacíos
    When hago clic en "Log in"
    And completo el formulario de login con:
      | username | <username> |
      | password | <password> |
    And hago clic en el botón "Log in" del modal
    Then debería aparecer un alert con el mensaje "Please fill out Username and Password."
    And no debería haber iniciado sesión

    Examples:
      | username     | password     |
      |              | somepassword |
      | someuser     |              |
      |              |              |

  @negative @login @validation @injection
  Scenario Outline: Login con inyección en username
    When hago clic en "Log in"
    And completo el formulario de login con:
      | username | <username> |
      | password | password |
    And hago clic en el botón "Log in" del modal
    Then debería aparecer un alert con el mensaje "Wrong password."
    And no debería haber iniciado sesión

    Examples:
      | username                  |
      | ' OR 1=1 --               |
      | <script>alert(1)</script> |

  @negative @login @validation
  Scenario: Login con caracteres especiales en password
    When hago clic en "Log in"
    And completo el formulario de login con:
      | username | qatest__12026 |
      | password | <>!@#$%^&*() |
    And hago clic en el botón "Log in" del modal
    Then debería aparecer un alert con el mensaje "Wrong password."
    And no debería haber iniciado sesión

  @negative @login @validation
  Scenario: Login con usuario que no existe
    When hago clic en "Log in"
    And completo el formulario de login con:
      | username | usuario_inexistente_12345 |
      | password | password123 |
    And hago clic en el botón "Log in" del modal
    Then debería aparecer un alert con el mensaje "User does not exist."
    And no debería haber iniciado sesión

  @negative @login @validation
  Scenario: Login con contraseña incorrecta
    When hago clic en "Log in"
    And completo el formulario de login con:
      | username | qatest__12026 |
      | password | WrongPassword99 |
    And hago clic en el botón "Log in" del modal
    Then debería aparecer un alert con el mensaje "Wrong password."
    And no debería haber iniciado sesión

  @negative @login @validation @boundary
  Scenario: Login con valores extremadamente largos
    When hago clic en "Log in"
    And completo el formulario de login con:
      | username | aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz |
      | password | password |
    And hago clic en el botón "Log in" del modal
    Then debería aparecer un alert con el mensaje "Wrong password."
    And no debería haber iniciado sesión

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