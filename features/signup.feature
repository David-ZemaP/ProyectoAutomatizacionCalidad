Feature: Registro y validación de usuario en DemoBlaze
  Como usuario de DemoBlaze
  Quiero registrarme y validar que el registro maneja correctamente casos borde
  Para asegurar la robustez del formulario de creación de cuenta

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @positive @signup @first_run_only 
  Scenario: Registro exitoso con validación mediante login
    When me registro con el nuevo usuario "qatest__12026" y la contraseña "12026testerqa__"
    And inicio sesión con el usuario "qatest__12026" y la contraseña "12026testerqa__"
    Then debería ver el saludo de bienvenida para el usuario "qatest__12026"

  @negative @signup @validation
  Scenario Outline: Registro inválido con datos de validación
    When intento registrarme con el usuario "<username>" y la contraseña "<password>"
    Then debería ver una advertencia de error de registro

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
    When intento registrarme con el usuario existente "qatest__12026" y la contraseña "12026testerqa__"
    Then debería ver el mensaje de alerta "This user already exist."

  @negative @signup @ui
  Scenario Outline: Cerrar formulario de registro con <método>
    When abro el formulario de registro
    And cierro el formulario de registro usando el método "<método>"
    Then el formulario de registro debería cerrarse

    Examples:
      | método |
      | Close  |
      | X      |
