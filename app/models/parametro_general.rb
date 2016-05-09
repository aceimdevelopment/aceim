# encoding: utf-8

#creada por db2models
class ParametroGeneral < ActiveRecord::Base

  def self.revisar_programaciones
    aux = ""
    Inscripcion.all.each do |inscripcion|

      if inscripcion.abrir_ahora?
        inscripcion.tipo_estado_inscripcion_curso_id = 'AB'
        aux += "Inscripcion Abierta de #{inscripcion.descripcion} a las #{DateTime.now} | " if inscripcion.save
      end

      if inscripcion.cerrar_ahora?
        inscripcion.tipo_estado_inscripcion_curso_id = 'CE'
        aux += "Inscripcion Cerrada de #{inscripcion.descripcion} a las #{DateTime.now}" if inscripcion.save
      end
    end

    return aux;
    
  end


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

  def self.inscripcion_regulares_abierta                                          
    ParametroGeneral.first(:conditions=>["id = ?", "INSCRIPCION_ABIERTA"]).valor == "SI"
  end

  # def self.inscripcion_abierta_ingles_adulto                                          
  #   ParametroGeneral.first(:conditions=>["id = ?", "INSCRIPCION_ABIERTA_INGLES_ADULTO"]).valor == "SI"
  # end

  def self.inscripcion_cambio_abierta                                          
    ParametroGeneral.first(:conditions=>["id = ?", "INSCRIPCION_PERMITIR_CAMBIO_HORARIO"]).valor == "SI"
  end

  def self.monto_planilla
     monto_planilla = ParametroGeneral.first(:conditions=>["id = ?", "COSTO_PLANILLA"]).valor.to_i
  end

  def self.inscripcion_ninos_abierta                                          
    ParametroGeneral.first(:conditions=>["id = ?", "INSCRIPCION_MODO_NINOS"]).valor == "SI"
  end

  def self.costo_ninos
    ide = ParametroGeneral.first(:conditions=>["id = ?", "COSTO_NINOS"]).valor.to_f
  end

  def self.costo_examen
    ide = ParametroGeneral.first(:conditions=>["id = ?", "COSTO_EXAMEN"]).valor.to_f
  end

  def self.costo_nuevos
    ide = ParametroGeneral.first(:conditions=>["id = ?", "COSTO_NUEVOS"]).valor.to_f
  end

  def self.programar_apertura_nuevos (minutos)
    sleep minutos
    puts "Abriendo inscripcion"
    inscripcion_nuevos = ParametroGeneral.find("INSCRIPCION_NUEVOS_ABIERTA")
    inscripcion_nuevos.valor = "SI"
    inscripcion_nuevos.save
  end

  def self.abrir_inscripcion_nuevos
    inscripcion_nuevos = ParametroGeneral.find("INSCRIPCION_NUEVOS_ABIERTA")
    inscripcion_nuevos.valor = "SI"
    inscripcion_nuevos.save
  end

  def self.cerrar_inscripcion_nuevos
    inscripcion_nuevos = ParametroGeneral.find("INSCRIPCION_NUEVOS_ABIERTA")
    inscripcion_nuevos.valor = "NO"
    inscripcion_nuevos.save
  end



  def self.abrir_listados
    listados_abiertos = ParametroGeneral.find("LISTADOS_ABIERTOS")
    listados_abiertos.valor = "SI"
    listados_abiertos.save
  end

end 
