require 'capybara/dsl'
require 'rspec/expectations'

def form
  @form ||= Form.new
end

Dado("que me encuentro en la página de inicio de DemoBlaze") do
  pagina_inicio.cargar
  pagina_inicio.validar_cargada
end

Entonces("debería ver el mensaje de alerta {string}") do |expected_message|
  validar_alerta(expected_message)
end

Entonces("debería mostrar un mensaje de error") do
  expect do
    aceptar_alerta
  end.not_to raise_error
end
