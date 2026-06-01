Feature: Carrito de compras en DemoBlaze
  Como usuario de DemoBlaze
  Quiero gestionar el carrito de compras
  Para agregar productos y realizar una compra

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @positive @cart
  Scenario: El carrito está vacío inicialmente
    When navego al carrito
    Then el carrito debería estar vacío

  @positive @cart
  Scenario: Agregar un producto al carrito y verlo en la lista
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When navego al carrito
    Then el carrito debería tener productos en la lista

  @positive @cart @smoke
  Scenario: Place Order exitoso
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When navego al carrito
    Then el carrito debería tener productos en la lista
    When realizo el pedido con:
      | name        | Test User       |
      | country     | Uruguay         |
      | city        | Montevideo      |
      | credit card | 1234567890123456 |
      | month       | December        |
      | year        | 2027            |
    Then debería aparecer la confirmación de compra exitosa

  @positive @cart
  Scenario: Eliminar producto del carrito
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When navego al carrito
    Then el carrito debería tener productos en la lista
    When elimino el producto del carrito
    Then el carrito debería estar vacío

  @positive @cart
  Scenario: Total del carrito con múltiples productos
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When vuelvo a la página de inicio
    And hago clic en el segundo producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When navego al carrito
    Then el carrito debería tener productos en la lista
    And el total debería ser la suma de los productos

  @positive @cart
  Scenario: Agregar el mismo producto dos veces al carrito
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When vuelvo a la página de inicio
    And hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When navego al carrito
    Then el carrito debería tener 2 productos en la lista

  @negative @cart @validation
  Scenario: Place Order con campos vacíos
    When navego al carrito
    When realizo el pedido vacío
    Then debería mostrar un mensaje de error

  @negative @cart @validation
  Scenario: Place Order con solo nombre sin tarjeta
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When navego al carrito
    Then el carrito debería tener productos en la lista
    When realizo el pedido con:
      | name | Test User |
    Then debería mostrar un mensaje de error

  @positive @cart
  Scenario: Verificar detalles de confirmación de compra
    When hago clic en el primer producto de la lista
    And hago clic en "Add to cart"
    Then debería aparecer un alert con el mensaje "Product added"
    When navego al carrito
    Then el carrito debería tener productos en la lista
    When realizo el pedido con:
      | name        | Test User       |
      | country     | Uruguay         |
      | city        | Montevideo      |
      | credit card | 1234567890123456 |
      | month       | December        |
      | year        | 2027            |
    Then la confirmación debería mostrar los detalles de la compra
    When cierro la confirmación de compra
    Then el carrito debería estar vacío
