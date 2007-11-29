require File.dirname(__FILE__) + '/test_helper'
require 'holidays/europe'

class RegionTests < Test::Unit::TestCase
  def test_nl
    {Date.civil(2008,1,1) => 'Nieuwjaar', 
     Date.civil(2008,3,21) => 'Goede Vrijdag', 
     Date.civil(2008,3,23) => 'Pasen',
     Date.civil(2008,3,24) => 'Pasen',
     Date.civil(2008,4,30) => 'Koninginnedag',
     Date.civil(2008,5,1) => 'Hemelvaartsdag', # Ascension, Easter+39
     Date.civil(2008,5,5) => 'Bevrijdingsdag',
     Date.civil(2008,5,11) => 'Pinksteren', # Pentecost, Easter+49
     Date.civil(2008,5,12) => 'Pinksteren', # Pentecost, Easter+50
     Date.civil(2008,12,25) => 'Kerstmis',
     Date.civil(2008,12,26) => 'Kerstmis'}.each do |date, name|
      assert_equal name, Holidays.on(date, :nl)[0][:name]
    end
  end

  def test_pt
    {Date.civil(2008,1,1) => 'Ano Novo', 
     Date.civil(2005,2,8) => 'Carnaval',
     Date.civil(2006,2,28) => 'Carnaval',
     Date.civil(2007,2,20) => 'Carnaval',
     Date.civil(2008,2,5) => 'Carnaval',
     Date.civil(2008,3,21) => 'Sexta-feira Santa', 
     Date.civil(2008,3,23) => 'Páscoa',
     Date.civil(2008,4,25) => 'Dia da Liberdade',
     Date.civil(2008,5,1) => 'Dia do Trabalhador',
     Date.civil(2005,5,26) => 'Corpo de Deus',
     Date.civil(2007,6,7) => 'Corpo de Deus',
     Date.civil(2008,5,22) => 'Corpo de Deus',
     Date.civil(2008,6,10) => 'Dia de Portugal',
     Date.civil(2008,8,15) => 'Assunção de Nossa Senhora',
     Date.civil(2008,10,5) => 'Implantação da República',
     Date.civil(2008,11,1) => 'Todos os Santos',
     Date.civil(2008,12,1) => 'Restauração da Independência',
     Date.civil(2008,12,8) => 'Imaculada Conceição',
     Date.civil(2008,12,25) => 'Natal'}.each do |date, name|
      assert_equal name, Holidays.on(date, :pt)[0][:name]
    end
  end


  def test_it
    {Date.civil(2007,1,1) => 'Capodanno', 
     Date.civil(2007,1,6) => 'Epifania',
     Date.civil(2007,4,8) => 'Pasqua',
     Date.civil(2007,4,9) => 'Lunedì dell\'Angelo',
     Date.civil(2007,4,25) => 'Festa della Liberazione',
     Date.civil(2007,5,1) => 'Festa dei Lavoratori',
     Date.civil(2007,6,2) => 'Festa della Repubblica',
     Date.civil(2007,8,15) => 'Assunzione',
     Date.civil(2007,11,1) => 'Ognissanti',
     Date.civil(2007,12,8) => 'Immacolata Concezione',
     Date.civil(2007,12,25) => 'Natale',
     Date.civil(2007,12,26) => 'Santo Stefano'}.each do |date, name|
      assert_equal name, Holidays.on(date, :it)[0][:name]
    end
  end


  def test_se
    {Date.civil(2008,1,1) => 'Nyårsdagen', 
     Date.civil(2008,1,6) => 'Trettondedag jul',
     Date.civil(2008,3,21) => 'Långfredagen', 
     Date.civil(2008,3,23) => 'Påskdagen', 
     Date.civil(2008,3,24) => 'Annandag påsk',
     Date.civil(2008,5,1) => 'Första maj',
     Date.civil(2008,5,1) => 'Kristi himmelsfärdsdag',
     Date.civil(2008,5,11) => 'Pingstdagen',
     Date.civil(2008,6,6) => 'Nationaldagen',
     Date.civil(2005,6,25) => 'Midsommardagen',
     Date.civil(2006,6,24) => 'Midsommardagen',
     Date.civil(2007,6,23) => 'Midsommardagen',
     Date.civil(2008,6,21) => 'Midsommardagen',
     Date.civil(2005,11,5) => 'Alla helgons dag',
     Date.civil(2006,11,4) => 'Alla helgons dag',
     Date.civil(2007,11,3) => 'Alla helgons dag',
     Date.civil(2008,11,1) => 'Alla helgons dag',
     Date.civil(2008,12,25) => 'Juldagen',
     Date.civil(2008,12,26) => 'Annandag jul'}.each do |date, name|
      assert_equal name, Holidays.on(date, :se)[0][:name]
    end
  end


end
