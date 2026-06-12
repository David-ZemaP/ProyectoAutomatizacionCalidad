require 'json'
require 'net/http'
require 'uri'

module CategoriaApiHelper
  def categoria_api(categoria)
    api_category = {
      'Phones' => 'phone',
      'Laptops' => 'notebook',
      'Monitors' => 'monitor'
    }[categoria]

    raise ArgumentError, "Categoría no soportada: #{categoria}" unless api_category
    api_category
  end

  def productos_por_categoria(categoria)
    api_cat = categoria_api(categoria)
    uri = URI.parse(DemoblazeConstants::API_CATEGORIAS)
    request = Net::HTTP::Post.new(uri)
    request['Content-Type'] = 'application/json'
    request.body = { cat: api_cat }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    raise "Error consultando la API de categorías: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body).fetch('Items', []).map { |item| item.fetch('title').to_s.strip }
  end
end

World(CategoriaApiHelper) if respond_to?(:World)
