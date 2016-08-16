# encoding: utf-8

desc "transfiere todas las Notas de los exámenes a los correspondientes historiales"
task :transferir_notas_a_historiales => :environment do
  puts 'Iniciando Trasferencia...'

  begin
	  @estudiante_examenes = EstudianteExamen.where("tipo_estado_estudiante_examen_id = 'COMPLETADO' OR tipo_estado_estudiante_examen_id = 'INICIADO'").delete_if{|ee| ee.examen.prueba and ee.examen.periodo_id!=ParametroGeneral.periodo_actual.id}

	  total_trasferidos = 0
	  total_ee = @estudiante_examenes.count
	  @estudiante_examenes.each do |ee|
	    total_trasferidos += 1 if ee.transferir_nota_escrita_a_historial
	    puts "Guardado ##{total_trasferidos}/#{total_ee}."
	  end
	  puts "Total de exámenes: #{total_ee}. Total transferidos: #{total_trasferidos}"
  rescue Exception => e
    puts = "Error: #{e.message}"
  end
end
