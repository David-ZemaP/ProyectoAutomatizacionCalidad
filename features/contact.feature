Feature: Formulario de contacto en DemoBlaze
  Como usuario de DemoBlaze
  Quiero enviar un mensaje de contacto
  Para comunicarme con el equipo del sitio

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @positive @contact 
  Scenario: Enviar mensaje de contacto exitosamente
    When envío un mensaje de contacto con el correo "test@example.com", nombre "Test User" y mensaje "Este es un mensaje de prueba"
    Then el sistema debería confirmar el envío con el mensaje "Thanks for the message!!"

  @negative @contact @ui
  Scenario Outline: Cerrar modal de contacto con <método>
    When abro el formulario de contacto
    And cierro el formulario de contacto usando el método "<método>"
    Then el formulario de contacto debería cerrarse

    Examples:
      | método |
      | Close  |
      | X      |
