require_relative '../pages/pagina_base'

Dir[File.join(__dir__, '../pages/**/*.rb')].sort.each do |file|
  next if File.basename(file) == 'pagina_base.rb'

  require file
end

module PageObjectsHelper
  def pagina_inicio
    @pagina_inicio ||= PaginaInicio.new
  end

  def componente_navbar
    @componente_navbar ||= ComponenteNavbar.new
  end

  def modal_login
    @modal_login ||= ModalLogin.new
  end

  def modal_registro
    @modal_registro ||= ModalRegistro.new
  end

  def modal_contacto
    @modal_contacto ||= ModalContacto.new
  end

  def modal_acerca_de
    @modal_acerca_de ||= ModalAcercaDe.new
  end

  def pagina_detalle_producto
    @pagina_detalle_producto ||= PaginaDetalleProducto.new
  end

  def pagina_carrito
    @pagina_carrito ||= PaginaCarrito.new
  end

  def modal_orden
    @modal_orden ||= ModalOrden.new
  end
end

World(PageObjectsHelper)