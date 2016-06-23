# encoding: utf-8

desc "transfiere todas las Notas de los exámenes a los correspondientes historiales"
task :transferir_notas_a_historiales => :environment do
  puts 'Iniciando Trasferencia...'

  estudiante_examenes = EstudianteExamen.all.delete_if{|ee| ee.examen.prueba}
  total_trasferidos = 0
  total_ee = estudiante_examenes.count
  estudiante_examenes.each do |ee|
    total_trasferidos += 1 if ee.transfrir_nota_escrita2_a_historial
    puts "Guardado ##{total_trasferidos}/#{total_ee}."
  end
  puts "Total de exámenes: #{total_ee}. Total transferidos: #{total_trasferidos}"
end
