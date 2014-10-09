desc "Apertura de Inscripcion de nuevos"
task :apertura_nuevos => :environment do
  # while !((DateTime.now.year.eql? 2014) and (DateTime.now.month.eql? 10) and (DateTime.now.day.eql? 8) and (DateTime.now.hour.eql? 22) ) do
  while !((DateTime.now.year.eql? 2014) and (DateTime.now.month.eql? 10) and (DateTime.now.day.eql? 9) and (DateTime.now.hour.eql? 7)) do
    sleep 1
    puts '.'
  end
  ParametroGeneral.abrir_inscripcion_nuevos
  # ParametroGeneral.abrir_listados
  puts 'Inscripcion Abierta para nuevos...'
end
