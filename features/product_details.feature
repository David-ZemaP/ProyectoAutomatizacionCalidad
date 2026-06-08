Feature: Detalles de producto en DemoBlaze
  Como usuario de DemoBlaze
  Quiero ver los detalles de un producto al hacer clic en él
  Para revisar la información antes de agregarlo al carrito

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @positive @products @details @smoke
  Scenario: Los productos se listan correctamente en el catálogo principal
    Then debería ver productos disponibles en el catálogo
    And cada producto listado debería mostrar su respectivo nombre y precio

  @positive @products @details
  Scenario: Navegar a los detalles de un producto al seleccionarlo
    When selecciono el producto "Samsung galaxy s6"
    Then debería ver la página de detalles del producto
    And los detalles deberían incluir nombre, precio, descripción e imagen del producto

  @positive @products @details @navigation
  Scenario: Regresar al catálogo principal desde el detalle del producto
    Given que estoy visualizando los detalles del producto "Samsung galaxy s6"
    When regreso al catálogo principal
    Then debería ver el catálogo de productos disponible nuevamente

  @positive @products @details @add_to_cart
  Scenario: Agregar un producto al carrito desde su página de detalle
    Given que estoy visualizando los detalles del producto "Samsung galaxy s6"
    When agrego el producto al carrito de compras
    Then la tienda debería confirmar la adición del producto

  @positive @products @navigation
  Scenario: Navegar entre las páginas del catálogo
    When avanzo a la siguiente página del catálogo de productos
    Then debería ver nuevos productos listados en la página
    When retrocedo a la página anterior del catálogo
    Then debería ver los productos iniciales listados en la página

  @positive @products @details
  Scenario: El precio del producto en detalle tiene formato en dólares
    When selecciono el producto "Samsung galaxy s6"
    Then el precio del producto debería comenzar con el símbolo "$" y contener solo dígitos numéricos

  @positive @products @details
  Scenario: El nombre del producto seleccionado coincide con su detalle
    When selecciono el producto "Samsung galaxy s6"
    Then el nombre visible en la página de detalles debería ser "Samsung galaxy s6"

  @positive @products @details
  Scenario: Cada producto muestra una imagen descriptiva en el catálogo principal
    Then debería ver productos disponibles en el catálogo
    And cada producto listado debería contar con una imagen visible
