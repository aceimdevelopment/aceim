# encoding: utf-8

module Programador

  def self.programar_apertura_nuevos (minutos)
    sleep minutos
    inscripcion_nuevos = ParametroGeneral.find("INSCRIPCION_NUEVOS_ABIERTA")
    inscripcion_nuevos.valor = "SI"
    inscripcion_nuevos.save

  end

  def self.transferir_notas_a_historiales

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