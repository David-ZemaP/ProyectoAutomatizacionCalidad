Before do
  page.execute_script("localStorage.clear()")
rescue
end

Before("@products") do
  pagina_inicio.cargar
  pagina_inicio.validar_catalogo_visible
end

Before("@add_to_cart") do
  @initial_cart_count = componente_navbar.cantidad_carrito
end

Before("@navigation") do
  pagina_inicio.cargar
  pagina_inicio.validar_paginacion_disponible
end

Before("@smoke") do
  pagina_inicio.cargar
  pagina_inicio.validar_navbar_visible
end

RUN_ONCE_DIR = File.join(__dir__, "..", ".run_once")

Before("@first_run_only") do |scenario|
  marker = File.join(RUN_ONCE_DIR, scenario.name.gsub(/\s+/, "_").gsub(/[^\w]/, "").downcase + ".marker")
  @run_once_marker = marker

  if File.exist?(marker)
    skip_this_scenario("Ya se ejecutó: #{scenario.name}")
  end
end

After("@first_run_only") do
  FileUtils.mkdir_p(RUN_ONCE_DIR)
  File.write(@run_once_marker, "Ejecutado el: #{Time.now}")
end
