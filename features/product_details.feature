Feature: Detalles de producto en DemoBlaze
  Como usuario de DemoBlaze
  Quiero ver los detalles de un producto al hacer clic en él
  Para revisar la información antes de agregarlo al carrito

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @positive @products @details @smoke
  Scenario: Los productos se listan correctamente en la página principal
    Then debería haber productos visibles en la página
    And cada producto debería tener nombre y precio visible

  @positive @products @details
  Scenario: Navegar a la página de detalles al hacer clic en un producto
    When hago clic en el primer producto de la lista
    Then debería estar en la página de detalles del producto
    And la página debería mostrar los datos del producto:
      | campo       |
      | nombre      |
      | precio      |
      | descripción |
      | imagen      |
      | Add to cart |

  @positive @products @details @navigation
  Scenario: Volver a la página principal desde la página de producto
    When hago clic en el primer producto de la lista
    Then debería estar en la página de detalles del producto
    When vuelvo a la página de inicio
    Then debería estar en la página principal
    And debería haber productos visibles en la página

  @positive @products @details @add_to_cart
  Scenario: Agregar producto al carrito desde la página de detalles
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"

  @positive @products @navigation
  Scenario: Navegar entre páginas de productos
    Then debería haber productos visibles en la página
    When hago clic en "Next" de la paginación
    Then debería haber productos visibles en la página
    When hago clic en "Previous" de la paginación
    Then debería haber productos visibles en la página

  @positive @products @details
  Scenario: El precio del producto sigue el formato esperado
    When hago clic en el primer producto de la lista
    Then el precio debería comenzar con "$" y contener solo dígitos

  @positive @products @details
  Scenario: El nombre del producto en la lista coincide con la página de detalles
    When recuerdo el nombre del primer producto en la lista
    And hago clic en el primer producto de la lista
    Then el nombre del producto en detalle debería coincidir

  @positive @products @details
  Scenario: Cada producto tiene una imagen visible en la página principal
    Then debería haber productos visibles en la página
    And cada producto debería tener una imagen visible
