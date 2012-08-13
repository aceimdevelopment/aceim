#creada por db2models
class ParametroGeneral < ActiveRecord::Base

  def self.periodo_actual
    ide = ParametroGeneral.first(:conditions=>["id = ?", "PERIODO_ACTUAL"])
    Periodo.first(:conditions => ["id = ?" , ide.valor])
  end


  def self.capacidad_curso
    ide = ParametroGeneral.first(:conditions=>["id = ?", "CAPACIDAD_CURSO"]).valor.to_i
  end

  def self.periodo_inscripcion
    ide = ParametroGeneral.first(:conditions=>["id = ?", "PERIODO_INSCRIPCION"])
    Periodo.first(:conditions => ["id = ?" , ide.valor])
  end

  def self.periodo_anterior
    ide = ParametroGeneral.first(:conditions=>["id = ?", "PERIODO_ANTERIOR"])
    Periodo.first(:conditions => ["id = ?" , ide.valor])
  end
  
  def self.periodo_calificacion
    ide = ParametroGeneral.first(:conditions=>["id = ?", "PERIODO_CALIFICACION"])
    Periodo.first(:conditions => ["id = ?" , ide.valor])
  end
  
  def self.calificacion_plazo
    ParametroGeneral.first(:conditions=>["id = ?", "CALIFICACION_PLAZO"]).valor
  end                       
  
  def self.inscripcion_nuevos_abierta                                          
    ParametroGeneral.first(:conditions=>["id = ?", "INSCRIPCION_NUEVOS_ABIERTA"]).valor == "SI"
  end

  def self.monto_planilla
     monto_planilla = ParametroGeneral.first(:conditions=>["id = ?", "COSTO_PLANILLA"]).valor.to_i
  end


end 
