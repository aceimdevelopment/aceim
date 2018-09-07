#encoding: utf-8
#creada por db2models
class EstudianteNivelacion < ActiveRecord::Base

  #autogenerado por db2models
  set_primary_keys :usuario_ci,:periodo_id,:idioma_id,:tipo_categoria_id  

  #autogenerado por db2models
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['usuario_ci']

  #autogenerado por db2models
  belongs_to :periodo,
    :class_name => 'Periodo',
    :foreign_key => ['periodo_id']
    
  
  belongs_to :tipo_curso,
    :class_name => 'TipoCurso',
    :foreign_key => ['idioma_id','tipo_categoria_id']
    
    
  def inscrito?
    !!HistorialAcademico.where(:usuario_ci => usuario_ci,
      :periodo_id => periodo_id,
      :idioma_id => idioma_id,
      :tipo_categoria_id => tipo_categoria_id).first
  end          

  def descripcion 
    "Estudiante Nivelación - #{tipo_curso.descripcion}"
  end

  def descripcion_con_periodo
    "Estudiante Nivelación - #{tipo_curso.descripcion} - (#{periodo_id})"
  end

  
  def estado
    return "Inscrito" if inscrito?
    return "No inscrito"
  end

  def estado_confirmado
    return "Confirmado" if confirmado == 1
    return "No confirmado"
  end


  
  def cuenta_nueva
    if true || tipo_nivel_id == "BI" || tipo_categoria_id == "TE" || tipo_categoria_id == "NI"
      return "FUNDEIM"
    end
    return "FHyE"
  end
  
  def cuenta_nombre
    return "FUNDEIM (RIF: J-30174529-9) "
    #if true || tipo_nivel_id == "BI" || tipo_categoria_id == "TE" #esto ya no se usa
    #  return "FUNDEIM"
    #end
    #return "FACULTAD DE HUMANIDADES Y EDUCACIÓN"
  end

  def cuenta_numero
    return "0102-0140-34000442688-4"
    #if true || tipo_nivel_id == "BI" || tipo_categoria_id == "TE" #esto ya no se usa
    #  return "0102-0140-34000442688-4"
    #end
    #return "0102-0552-2900-0000-1423"
  end  
  
  
  def cuenta_monto
    examen = ParametroGeneral.costo_examen.to_f
    nuevos = ParametroGeneral.costo_nuevos.to_f
    total = examen + nuevos
    return "Prueba: #{sprintf("%.0f",examen)}Bs.S + Nivel: #{sprintf("%.0f",nuevos)}Bs.S = Monto Total: #{sprintf("%.0f",total)}Bs.S"
  end


end
