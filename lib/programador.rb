# encoding: utf-8
module Programador

  def self.programar_apertura_nuevos (minutos)
    sleep minutos
    inscripcion_nuevos = ParametroGeneral.find("INSCRIPCION_NUEVOS_ABIERTA")
    inscripcion_nuevos.valor = "SI"
    inscripcion_nuevos.save

  end

end