Feature: Registro y validación de usuario en DemoBlaze
  Como usuario de DemoBlaze
  Quiero registrarme y validar que el registro maneja correctamente casos borde
  Para asegurar la robustez del formulario de creación de cuenta

  Background:
    Given estoy en la página de inicio de DemoBlaze
    And hago clic en "Sign up"

  @positive @signup @first_run_only
  Scenario: Registro exitoso con validación mediante login
    When me registro con el usuario "qatest__12026" y contraseña "12026testerqa__"
    And hago clic en "Log in"
    And ingreso "qatest__12026" en el campo "Username" del modal
    And ingreso "12026testerqa__" en el campo "Password" del modal
    And hago clic en el botón "Log in" del modal
    Then debería ver "Welcome qatest__12026" en el navbar

  @negative @signup @validation
  Scenario Outline: Registro inválido con datos de validación
    When ingreso "<username>" en el campo "Username" del modal de signup
    And ingreso "<password>" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error

    @empty
    Examples: Campos vacíos
      | username     | password     |
      |              | mypassword   |
      | newuser_test |              |
      |              |              |

    @injection
    Examples: Entradas con inyección o caracteres especiales
      | username                  | password       |
      | <script>alert(1)</script> | password123    |
      | ' OR 1=1 --               | password123    |
      | newuser_special           | <>!@#$%^&*()   |

    @boundary
    Examples: Valores de frontera
      | username                                                                                                                                                                                                                                                           | password    |
      | aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz | password123 |

  @negative @signup
  Scenario: Registro con usuario ya existente
    When ingreso "qatest__12026" en el campo "Username" del modal de signup
    And ingreso "12026testerqa__" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería aparecer un alert con el mensaje "This user already exist."

  @negative @signup @ui
  Scenario Outline: Cerrar modal de signup con <método>
    Then el modal de signup debería estar visible
    When cierro el modal de signup con "<método>"
    Then el modal de signup debería estar cerrado

    Examples:
      | método |
      | Close  |
      | X      |
