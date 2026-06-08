Feature: Filtrado de productos por categoría en DemoBlaze
  Como usuario de DemoBlaze
  Quiero filtrar productos por categoría
  Para encontrar rápidamente los productos que me interesan

  Background:
    Given que me encuentro en la página de inicio de DemoBlaze

  @positive @categories
  Scenario: Filtrar productos por la categoría Teléfonos
    When selecciono la categoría "Phones" para filtrar
    Then debería ver la lista de productos correspondiente a la categoría "Phones"

  @positive @categories
  Scenario: Filtrar productos por la categoría Laptops
    When selecciono la categoría "Laptops" para filtrar
    Then debería ver la lista de productos correspondiente a la categoría "Laptops"

  @positive @categories
  Scenario: Filtrar productos por la categoría Monitores
    When selecciono la categoría "Monitors" para filtrar
    Then debería ver la lista de productos correspondiente a la categoría "Monitors"

  @positive @categories @navigation
  Scenario: Volver a ver todos los productos después de filtrar por categoría
    Given que he seleccionado la categoría "Phones" para filtrar
    When regreso a la página de inicio
    Then debería ver la lista completa de todos los productos disponibles

  @positive @categories @navigation
  Scenario: Cambiar de categoría directamente
    When selecciono la categoría "Phones" para filtrar
    And selecciono la categoría "Laptops" para filtrar
    Then debería ver la lista de productos correspondiente a la categoría "Laptops"

  @positive @categories
  Scenario: El panel de categorías muestra todas las opciones disponibles
    Then el menú lateral de categorías debería mostrar "Phones", "Laptops" y "Monitors"
