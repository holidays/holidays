# encoding: utf-8
require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

# This file is generated by the Ruby Holiday gem.
#
# Definitions loaded: definitions/ve.yaml
class VeDefinitionTests < Test::Unit::TestCase  # :nodoc:

  def test_ve
    assert_equal "Año Nuevo", (Holidays.on(Date.civil(2013, 1, 1), [:ve])[0] || {})[:name]

    assert_equal "Lunes Carnaval", (Holidays.on(Date.civil(2013, 2, 11), [:ve])[0] || {})[:name]

    assert_equal "Martes Carnaval", (Holidays.on(Date.civil(2013, 2, 12), [:ve])[0] || {})[:name]

    assert_equal "Jueves Santo", (Holidays.on(Date.civil(2013, 3, 28), [:ve])[0] || {})[:name]

    assert_equal "Viernes Santo", (Holidays.on(Date.civil(2013, 3, 29), [:ve])[0] || {})[:name]

    assert_equal "Declaración Independencia", (Holidays.on(Date.civil(2013, 4, 19), [:ve])[0] || {})[:name]

    assert_equal "Día del Trabajador", (Holidays.on(Date.civil(2013, 5, 1), [:ve])[0] || {})[:name]

    assert_equal "Aniversario Batalla de Carabobo", (Holidays.on(Date.civil(2013, 6, 24), [:ve])[0] || {})[:name]

    assert_equal "Día de la Independencia", (Holidays.on(Date.civil(2013, 7, 5), [:ve])[0] || {})[:name]

    assert_equal "Natalicio de Simón Bolívar", (Holidays.on(Date.civil(2013, 7, 24), [:ve])[0] || {})[:name]

    assert_equal "Día de la Resistencia Indígena", (Holidays.on(Date.civil(2013, 10, 12), [:ve])[0] || {})[:name]

    assert_equal "Día de Navidad", (Holidays.on(Date.civil(2013, 12, 25), [:ve])[0] || {})[:name]

  end
end
