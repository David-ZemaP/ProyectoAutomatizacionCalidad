Feature: Navegación del navbar en DemoBlaze
  Como usuario de DemoBlaze
  Quiero navegar por los links del navbar
  Para verificar que todos los enlaces responden correctamente

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @positive @navigation
  Scenario Outline: Navegar al link <link> del navbar
    When hago clic en "<link>"
    Then la navegación debería mostrar "<resultado>"

    Examples:
      | link     | resultado |
      | Home     | principal |
      | Contact  | contacto  |
      | About us | acerca_de |
      | Cart     | carrito   |

  @negative @navigation @ui
  Scenario Outline: Cerrar modal About us con <metodo>
    When hago clic en "About us"
    Then el modal About us debería estar visible
    When cierro el modal About us con "<metodo>"
    Then el modal About us debería estar cerrado

    Examples:
      | metodo |
      | Close  |
      | X      |
