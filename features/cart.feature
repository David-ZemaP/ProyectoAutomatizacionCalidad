Feature: Carrito de compras en DemoBlaze
  Como usuario de DemoBlaze
  Quiero gestionar el carrito de compras
  Para agregar productos y realizar una compra

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @positive @cart
  Scenario: El carrito está vacío inicialmente
    When accedo a mi carrito de compras
    Then el carrito de compras debería estar vacío

  @positive @cart
  Scenario: Agregar un producto al carrito y verlo en la lista
    When selecciono el producto "Samsung galaxy s6"
    And agrego el producto seleccionado al carrito
    And accedo a mi carrito de compras
    Then el producto "Samsung galaxy s6" debería figurar en mi carrito de compras

  @positive @cart @smoke
  Scenario: Realizar una compra exitosa
    Given que tengo el producto "Samsung galaxy s6" en mi carrito de compras
    When realizo la compra con los siguientes datos del comprador:
      | name        | Test User        |
      | country     | Uruguay          |
      | city        | Montevideo       |
      | credit card | 1234567890123456 |
      | month       | December         |
      | year        | 2027             |
    Then la compra debería ser confirmada exitosamente

  @positive @cart
  Scenario: Eliminar un producto del carrito
    Given que tengo el producto "Samsung galaxy s6" en mi carrito de compras
    When elimino el producto "Samsung galaxy s6" de la lista de compras
    Then el carrito de compras debería estar vacío

  @positive @cart
  Scenario: Total del carrito con múltiples productos
    Given que he agregado los productos "Samsung galaxy s6" y "Nokia lumia 1520" al carrito
    When accedo a mi carrito de compras
    Then el precio total debería reflejar la suma de los precios de los productos seleccionados

  @positive @cart
  Scenario: Agregar el mismo producto dos veces al carrito
    Given que he agregado el producto "Samsung galaxy s6" al carrito dos veces
    When accedo a mi carrito de compras
    Then el carrito de compras debería contener 2 productos

  @negative @cart @validation
  Scenario: Intentar realizar compra con campos obligatorios vacíos
    Given que tengo el producto "Samsung galaxy s6" en mi carrito de compras
    When intento realizar la compra dejando vacíos los campos obligatorios
    Then debería ver la advertencia de compra "Please fill out Name and Creditcard."

  @negative @cart @validation
  Scenario: Intentar realizar compra con solo nombre y sin tarjeta de crédito
    Given que tengo el producto "Samsung galaxy s6" en mi carrito de compras
    When intento realizar la compra ingresando solo el nombre "Test User" sin tarjeta
    Then debería ver la advertencia de compra "Please fill out Name and Creditcard."

  @positive @cart
  Scenario: Verificar detalles de la confirmación de compra
    Given que tengo el producto "Samsung galaxy s6" en mi carrito de compras
    When realizo la compra con los siguientes datos del comprador:
      | name        | Test User        |
      | country     | Uruguay          |
      | city        | Montevideo       |
      | credit card | 1234567890123456 |
      | month       | December         |
      | year        | 2027             |
    Then la confirmación debería detallar la transacción para "Test User" y la tarjeta "1234567890123456"
    And al cerrar la confirmación el carrito de compras debería quedar vacío
