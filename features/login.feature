Feature: Validación de login en DemoBlaze
  Como usuario de DemoBlaze
  Quiero validar que el login maneja correctamente casos borde
  Para asegurar la robustez del formulario de inicio de sesión

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @smoke @positive @login
  Scenario: Login exitoso con credenciales válidas
    When inicio sesión con el usuario "qatest__12026" y la contraseña "12026testerqa__"
    Then debería ver el saludo de bienvenida para el usuario "qatest__12026"

  @negative @login @validation @empty
  Scenario Outline: Login con campos vacíos
    When inicio sesión con el usuario "<username>" y la contraseña "<password>"
    Then debería ver el mensaje de alerta "Please fill out Username and Password."
    And no debería ingresar a la cuenta

    Examples:
      | username     | password     |
      |              | somepassword |
      | someuser     |              |
      |              |              |

  @negative @login @validation @injection
  Scenario Outline: Login con inyección en username
    When inicio sesión con el usuario "<username>" y la contraseña "password"
    Then debería ver el mensaje de alerta "Wrong password."
    And no debería ingresar a la cuenta

    Examples:
      | username                  |
      | ' OR 1=1 --               |
      | <script>alert(1)</script> |

  @negative @login @validation
  Scenario: Login con caracteres especiales en password
    When inicio sesión con el usuario "qatest__12026" y la contraseña "<>!@#$%^&*()"
    Then debería ver el mensaje de alerta "Wrong password."
    And no debería ingresar a la cuenta

  @negative @login @validation
  Scenario: Login con usuario que no existe
    When inicio sesión con el usuario "usuario_inexistente_12345" y la contraseña "password123"
    Then debería ver el mensaje de alerta "User does not exist."
    And no debería ingresar a la cuenta

  @negative @login @validation
  Scenario: Login con contraseña incorrecta
    When inicio sesión con el usuario "qatest__12026" y la contraseña "WrongPassword99"
    Then debería ver el mensaje de alerta "Wrong password."
    And no debería ingresar a la cuenta

  @negative @login @validation @boundary
  Scenario: Login con valores extremadamente largos
    When inicio sesión con el usuario "aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz" y la contraseña "password"
    Then debería ver el mensaje de alerta "Wrong password."
    And no debería ingresar a la cuenta

  @negative @login @ui
  Scenario Outline: Cerrar formulario de login con <método>
    When abro el formulario de inicio de sesión
    And cierro el formulario usando el método "<método>"
    Then el formulario de inicio de sesión debería cerrarse

    Examples:
      | método |
      | Close  |
      | X      |