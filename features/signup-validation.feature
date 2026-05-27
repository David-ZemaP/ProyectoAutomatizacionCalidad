Feature: Validación de registro en DemoBlaze
  Como usuario nuevo de DemoBlaze
  Quiero validar que el registro rechaza datos inválidos o maliciosos
  Para asegurar la robustez del formulario de creación de cuenta

  Background:
    Given estoy en la página de inicio de DemoBlaze
    And hago clic en "Sign up"

  @negative @signup @validation @empty
  Scenario: Registro con username vacío
    When ingreso "" en el campo "Username" del modal de signup
    And ingreso "mypassword" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error

  @negative @signup @validation @empty
  Scenario: Registro con password vacío
    When ingreso "newuser_test" en el campo "Username" del modal de signup
    And ingreso "" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error

  @negative @signup @validation @empty
  Scenario: Registro con ambos campos vacíos
    When ingreso "" en el campo "Username" del modal de signup
    And ingreso "" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error

  @negative @signup @validation @injection
  Scenario: Registro con intento de XSS en username
    When ingreso "<script>alert(1)</script>" en el campo "Username" del modal de signup
    And ingreso "password123" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error

  @negative @signup @validation @injection
  Scenario: Registro con SQL injection en username
    When ingreso "' OR 1=1 --" en el campo "Username" del modal de signup
    And ingreso "password123" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error

  @negative @signup @validation @injection
  Scenario: Registro con caracteres especiales en password
    When ingreso "newuser_special" en el campo "Username" del modal de signup
    And ingreso "<>!@#$%^&*()" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error

  @negative @signup @validation @boundary
  Scenario: Registro con username extremadamente largo
    When ingreso "aaaaaaaaaabbbbbbbbbbccccccccccddddddddddeeeeeeeeeeffffffffffgggggggggghhhhhhhhhhiiiiiiiiiijjjjjjjjjjkkkkkkkkkkllllllllllmmmmmmmmmmnnnnnnnnnnooooooooooppppppppppqqqqqqqqqqrrrrrrrrrrssssssssssttttttttttuuuuuuuuuuvvvvvvvvvvwwwwwwwwwwxxxxxxxxxxyyyyyyyyyyzzzzzzzzzz" en el campo "Username" del modal de signup
    And ingreso "password123" en el campo "Password" del modal de signup
    And hago clic en el botón "Sign up" del modal de signup
    Then debería mostrar un mensaje de error
