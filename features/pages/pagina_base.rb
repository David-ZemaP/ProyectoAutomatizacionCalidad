require 'capybara/dsl'
require 'rspec/expectations'
require_relative '../support/alert_helper'

class PaginaBase
  include Capybara::DSL
  include RSpec::Matchers
  include AlertHelper

  def esperar_css(*args, visible: true, wait: 10, **options)
    expect(page).to have_selector(*args, visible: visible, wait: wait, **options)
  end

  def esperar_no_css(*args, visible: true, wait: 10, **options)
    expect(page).to have_no_selector(*args, visible: visible, wait: wait, **options)
  end

  def click_seguro(*args, wait: 10, **options)
    find(*args, wait: wait, **options).click
  end

  def texto_de(*args, wait: 10, **options)
    find(*args, wait: wait, **options).text
  end
end
