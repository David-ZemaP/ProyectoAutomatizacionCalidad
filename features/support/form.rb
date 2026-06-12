require 'capybara/dsl'
require 'rspec/expectations'

class Form
  include RSpec::Matchers
  include Capybara::DSL

  def fill_field(identifier, type, value)
    case type
    when "input"
      fill_in identifier, with: value
    when "combo_box"
      select value, from: identifier
    else
      raise ArgumentError, "Tipo de campo no soportado: #{type}"
    end
  end

  def fill_in_fields(table, fields)
    table.raw.each do |row|
      field_name, field_value = row
      next unless fields.has_key?(field_name)

      field = fields[field_name]
      fill_field(field["id"], field["type"], field_value)
    end
  end

  def compare_fields_with_table(table, start_row, columns, path_table)
    table.raw.each do |row|
      field_name, field_value = row
      next unless columns.has_key?(field_name)

      xpath = path_table % [start_row, columns[field_name]]
      element = find(:xpath, xpath)
      data = element.text.empty? ? element.value : element.text
      expect(data).to eq(field_value)
      start_row += 1
    end
  end
end