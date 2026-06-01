Feature: Formulario de contacto en DemoBlaze
  Como usuario de DemoBlaze
  Quiero enviar un mensaje de contacto
  Para comunicarme con el equipo del sitio

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @positive @contact
  Scenario: Enviar mensaje de contacto válido
    When hago clic en "Contact"
    Then el modal de contacto debería estar visible
    When completo el formulario de contacto con:
      | contact email | test@example.com |
      | contact name | Test User |
      | message | Este es un mensaje de prueba |
    And hago clic en "Send message" en el modal de contacto
    Then debería aparecer un alert con el mensaje "Thanks for the message!!"

  @negative @contact @ui
  Scenario Outline: Cerrar modal de contacto con <metodo>
    When hago clic en "Contact"
    Then el modal de contacto debería estar visible
    When cierro el modal de contacto con "<metodo>"
    Then el modal de contacto debería estar cerrado

    Examples:
      | metodo |
      | Close  |
      | X      |
