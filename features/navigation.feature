Feature: Navegación del navbar en DemoBlaze
  Como usuario de DemoBlaze
  Quiero navegar por los links del navbar
  Para verificar que todos los enlaces responden correctamente

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @positive @navigation
  Scenario Outline: Navegar a la sección <sección> desde el menú de navegación
    When accedo a la sección "<sección>" desde el menú de navegación
    Then la aplicación debería mostrar la sección "<resultado>"

    Examples:
      | sección  | resultado |
      | Home     | principal |
      | Contact  | contacto  |
      | About us | acerca_de |
      | Cart     | carrito   |

  @negative @navigation @ui
  Scenario Outline: Cerrar la ventana Acerca de nosotros con <método>
    When abro la sección informativa Acerca de nosotros
    And cierro la ventana informativa usando el método "<método>"
    Then la ventana informativa Acerca de nosotros debería cerrarse

    Examples:
      | método |
      | Close  |
      | X      |
