Feature: Filtrado de productos por categoría en DemoBlaze
  Como usuario de DemoBlaze
  Quiero filtrar productos por categoría
  Para encontrar rápidamente los productos que me interesan

  Background:
    Given estoy en la página de inicio de DemoBlaze

  @positive @categories
  Scenario: Filtrar productos por Phones
    When selecciono la categoría "Phones"
    Then deberían mostrarse exactamente los mismos productos que retorna la API

  @positive @categories
  Scenario: Filtrar productos por Laptops
    When selecciono la categoría "Laptops"
    Then deberían mostrarse exactamente los mismos productos que retorna la API

  @positive @categories
  Scenario: Filtrar productos por Monitors
    When selecciono la categoría "Monitors"
    Then deberían mostrarse exactamente los mismos productos que retorna la API

  @positive @categories @navigation
  Scenario: Volver a ver todos los productos después de filtrar
    When selecciono la categoría "Phones"
    Then deberían mostrarse exactamente los mismos productos que retorna la API
    When vuelvo a la página de inicio
    Then deberían aparecer todos los productos nuevamente

  @positive @categories @navigation
  Scenario: Cambiar de Phones a Laptops directamente
    When selecciono la categoría "Phones"
    Then deberían mostrarse exactamente los mismos productos que retorna la API
    When selecciono la categoría "Laptops"
    Then deberían mostrarse exactamente los mismos productos que retorna la API

  @positive @categories
  Scenario: El panel de categorías muestra todas las opciones disponibles
    Then debería ver las categorías "Phones", "Laptops" y "Monitors"
