# encoding: utf-8

#creada por db2models
class HistorialAcademico < ActiveRecord::Base
  NOTAS = (-2..20).to_a
  NOTASSTRING = ("0".."20").to_a + ("00".."09").to_a -1
  NOTASPALABRAS = ["Sin Calificar","Pérdida por Inasistencia","Cero","Uno","Dos",
                   "Tres","Cuatro","Cinco", "Seis", "Siete", "Ocho","Nueve","Diez",
                   "Once","Doce","Trece","Catorce","Quince","Dieciseis","Diecisiete",
                   "Dieciocho","Diecinueve","Veinte"]
  SC = -2
  PI = -1
  
  EXAMENESCRITO1 = "EXA_ESC_1"
  EXAMENESCRITO2 = "EXA_ESC_2"
  EXAMENORAL = "EXA_ORA"
  OTRAS = "OTRAS"
  REDACCION = "REDACCION"
  
  #autogenerado por db2models
  set_primary_keys :usuario_ci,:idioma_id,:tipo_categoria_id,:tipo_nivel_id,:periodo_id,:seccion_numero

  has_many :notas_en_evaluaciones,
    :class_name => 'NotaEnEvaluacion',
    :foreign_key => ['usuario_ci', 'idioma_id', 'tipo_categoria_id', 
                     'tipo_nivel_id', 'periodo_id', 'seccion_numero']
  accepts_nested_attributes_for :notas_en_evaluaciones
  
  #autogenerado por db2models
  belongs_to :tipo_convenio,
    :class_name => 'TipoConvenio',
    :foreign_key => ['tipo_convenio_id']
    
  belongs_to :cuenta_bancaria,
    :class_name => 'CuentaBancaria',
    :foreign_key => ['cuenta_bancaria_id']
 
  #autogenerado por db2models
  belongs_to :tipo_estado_inscripcion,
    :class_name => 'TipoEstadoInscripcion',
    :foreign_key => ['tipo_estado_inscripcion_id']

  #autogenerado por db2models
  belongs_to :tipo_estado_calificacion,
    :class_name => 'TipoEstadoCalificacion',
    :foreign_key => ['tipo_estado_calificacion_id']

  #autogenerado por db2models
  belongs_to :seccion,
    :class_name => 'Seccion',
    :foreign_key => ['periodo_id','idioma_id','tipo_categoria_id','tipo_nivel_id','seccion_numero']
    
  #autogenerado por db2models
  belongs_to :estudiante_curso,
    :class_name => 'EstudianteCurso',
    :foreign_key => ['usuario_ci','idioma_id','tipo_categoria_id']
  
  belongs_to :usuario,
    :class_name => 'Usuario',
    :foreign_key => ['usuario_ci']  
    
  belongs_to :tipo_curso,
    :class_name => 'TipoCurso',
    :foreign_key => ['idioma_id','tipo_categoria_id']  
    
  belongs_to :periodo,
    :class_name => 'Periodo',
    :foreign_key => ['periodo_id']

  belongs_to :tipo_nivel,
    :class_name => 'TipoNivel',
    :foreign_key => ['tipo_nivel_id']
  

    def descripcion_completa
      "#{tipo_curso.descripcion} - #{tipo_nivel.descripcion} - Sección: #{seccion_numero}"
      
    end
  
  def tipo_categoria
    curso.tipo_curso.tipo_categoria
  end
  
  def idioma
    #Idioma.find(idioma_id)
    curso.tipo_curso.idioma
  end
  
  def tipo_nivel
    curso.tipo_nivel
  end


    
  def aprobo_curso?  
    return true if nota_final >= 10 && (tipo_categoria_id == "NI" || tipo_categoria_id == "TE")
    return true if nota_final >= 15 && (tipo_categoria_id != "NI" && tipo_categoria_id != "TE")
    return false
  end  


  def sin_calificar?
     HistorialAcademico.where(:periodo_id => periodo_id,
                              :idioma_id => idioma_id,
                              :tipo_categoria_id => tipo_categoria_id,
                              :tipo_nivel_id => tipo_nivel_id,
                              :seccion_numero => seccion_numero,
                              :nota_final => SC
                              ).limit(1).count > 0
  end
  
  def nota_en_evaluacion_sin_calificar?
    NotaEnEvaluacion.where(:idioma_id => idioma_id, 
                           :tipo_categoria_id => tipo_categoria_id, 
                           :tipo_nivel_id => tipo_nivel_id, 
                           :periodo_id => periodo_id, 
                           :seccion_numero => seccion_numero, 
                           :nota => SC
                           ).limit(1).count > 0
  end
  
  
  def curso
    Curso.first(:conditions => ["idioma_id = ? AND tipo_categoria_id = ? AND tipo_nivel_id = ?",
      idioma_id, tipo_categoria_id, tipo_nivel_id])
      #seccion.curso_periodo.curso
      #tipo_curso.curso
  end

  def seccion_tentativa 
    secciones = Seccion.all(:conditions => ["tipo_nivel_id = ? AND idioma_id = ? AND \
      tipo_categoria_id = ? AND periodo_id = ?",
      tipo_nivel_id,idioma_id,
      tipo_categoria_id, periodo_id], :order => "seccion_numero")
    secciones.each{  |sec|
       if sec.hay_cupo?
          return sec
       end
    }
    nil
  end
=begin 
  def horarios_disponibles
    secciones = Seccion.all(:conditions => ["tipo_nivel_id = ? AND idioma_id = ? AND \
      tipo_categoria_id = ? AND periodo_id = ? AND esta_abierta",
      tipo_nivel_id,idioma_id,
      tipo_categoria_id, periodo_id, 1])
    
    horarios_hay = []
    horarios_hay << HorarioSeccion.where(:seccion => secciones.first)
    
    secciones.each do |s|
      horario_seccion = HorarioSeccion.where(:seccion => s)
      if s.hay_cupo?
        horario_seccion.each do |h|
          no_esta = false
          horarios_hay.each do |hay|
            
            unless ((hay.tipo_bloque == h.tipo_bloque) and no_esta) 
            no_esta = true
            end
          end
          horarios_hay << horario_seccion if no_esta
        end
      end
      
    end
        
    return horario_seccion
  end
=end  
  def horarios_disponibles(permitir_cambios=true)   
    if permitir_cambios
      if seccion_numero
        seccion = Seccion.where(:idioma_id => idioma_id,
        :tipo_categoria_id => tipo_categoria_id,
        :tipo_nivel_id => tipo_nivel_id,
        :periodo_id => periodo_id,
        :seccion_numero => seccion_numero,
        :esta_abierta => true).limit(1).first
        if seccion && seccion.hay_cupo?
          return [seccion.horario] 
        end
      end
      ultimo_horario = nil
      begin
        ultimo_horario = estudiante_curso.ultimo_historial.seccion.horario
      rescue
      end       
      if ultimo_horario
        secciones = Seccion.where(:idioma_id => idioma_id,
        :tipo_categoria_id => tipo_categoria_id,
        :tipo_nivel_id => tipo_nivel_id,
        :periodo_id => periodo_id,
        :esta_abierta => true)                                
        secciones.each{|seccion|
          if seccion.horario == ultimo_horario && seccion.hay_cupo?
            self.seccion_numero = seccion.seccion_numero
            return [seccion.horario]
          end
        }
      end  
    end
    self.seccion_numero = nil       
    secciones = Seccion.where(:idioma_id => idioma_id,
    :tipo_categoria_id => tipo_categoria_id,
    :tipo_nivel_id => tipo_nivel_id,
    :periodo_id => periodo_id,
    :esta_abierta => true)                                
    return secciones.collect{|x| x.horario}.uniq.sort
  end
  
  
  def buscar_seccion(horario)
    secciones = Seccion.where(:idioma_id => idioma_id,
    :tipo_categoria_id => tipo_categoria_id,
    :tipo_nivel_id => tipo_nivel_id,
    :periodo_id => periodo_id,
    :esta_abierta => true)                                
    secciones.each{|seccion|
      if seccion.horario == horario && seccion.hay_cupo?
        self.seccion_numero = seccion.seccion_numero
        return seccion_numero
      end
    }
    return nil
  end
  
  def self.colocar_nota(nota)
    case nota
      when HistorialAcademico::SC 
         "SC"
      when HistorialAcademico::PI
        "PI"
      else
        sprintf("%02i",nota)
    end
  end
  
  def tiene_notas_adicionales?
    NotaEnEvaluacion.where(:usuario_ci => usuario_ci, :idioma_id => idioma_id, 
                           :tipo_categoria_id => tipo_categoria_id, 
                           :tipo_nivel_id => tipo_nivel_id,
                           :periodo_id => periodo_id, 
                           :seccion_numero => seccion_numero,
                           :tipo_evaluacion_id => EXAMENESCRITO1).limit(1).count > 0   
   
  end

  def crear_notas_adicionales
    arreglo = [EXAMENESCRITO1,EXAMENESCRITO2,EXAMENORAL,OTRAS, REDACCION]
    arreglo.each{ |a|
      nee = NotaEnEvaluacion.new(:usuario_ci => usuario_ci,
                           :idioma_id => idioma_id, 
                           :tipo_categoria_id => tipo_categoria_id, 
                           :tipo_nivel_id => tipo_nivel_id, 
                           :periodo_id => periodo_id, 
                           :seccion_numero => seccion_numero, 
                           :tipo_evaluacion_id => a,
                           :nota => -2
                           )
     nee.save
    }
  end
# temporal para verificar y crear notas de redaccion
# --------------------------------------------------------------------------
  def tiene_nota_redaccion?
    NotaEnEvaluacion.where(:usuario_ci => usuario_ci, :idioma_id => idioma_id, 
                           :tipo_categoria_id => tipo_categoria_id, 
                           :tipo_nivel_id => tipo_nivel_id,
                           :periodo_id => periodo_id, 
                           :seccion_numero => seccion_numero,
                           :tipo_evaluacion_id => REDACCION).limit(1).count > 0
  end

  def crear_nota_redaccion
      nee = NotaEnEvaluacion.new(:usuario_ci => usuario_ci,
                           :idioma_id => idioma_id, 
                           :tipo_categoria_id => tipo_categoria_id, 
                           :tipo_nivel_id => tipo_nivel_id, 
                           :periodo_id => periodo_id, 
                           :seccion_numero => seccion_numero, 
                           :tipo_evaluacion_id => REDACCION,
                           :nota => -2
                           )
     nee.save
  end
# --------------------------------------------------------------------------

  def nota_en_evaluacion(tipo_evalu)
      NotaEnEvaluacion.where(:usuario_ci => usuario_ci,
                           :idioma_id => idioma_id, 
                           :tipo_categoria_id => tipo_categoria_id, 
                           :tipo_nivel_id => tipo_nivel_id, 
                           :periodo_id => periodo_id, 
                           :seccion_numero => seccion_numero, 
                           :tipo_evaluacion_id => tipo_evalu
                           ).limit(0).first
  end
  
  def cambiar_estado_calificacion(tipo_categoria)
    case Seccion.tipo_categoria(tipo_categoria)
      when "Adultos"
        cambiar_est_calificacion(15)
      when "BBVA"
        cambiar_est_calificacion(15)
      when "Niños"
        cambiar_est_calificacion(10)
      when "Teens"
        cambiar_est_calificacion(10)
      when "Traducción"
        cambiar_est_calificacion(15)
      else
        cambiar_est_calificacion(15)
    end
  end
  
  def cambiar_est_calificacion(nota)
    if self.nota_final >= nota
      self.tipo_estado_calificacion_id = "AP"
    elsif self.nota_final == PI
      self.tipo_estado_calificacion_id = "PI"
    else
      self.tipo_estado_calificacion_id = "RE"
    end
    self.save
  end
  
  def cuenta_nombre 
    cuenta_bancaria.titular
  end
  
  def cuenta_banco 
    cuenta_bancaria.banco
  end

  def cuenta_numero
    cuenta_bancaria.num_cuenta
  end 
  
  def cuenta_nueva
    if tipo_nivel_id == "BI" || tipo_categoria_id == "TE" || tipo_categoria_id == "NI"
      return "FUNDEIM"
    end
    return "ESCUELA"
  end
  
  def cuenta_nombre_nueva 
    if tipo_nivel_id == "BI" || tipo_categoria_id == "TE" #esto ya no se usa
      return "FUNDEIM"
    end
    return "FACULTAD DE HUMANIDADES Y EDUCACIÓN"
  end

  def cuenta_numero_nueva
    if tipo_nivel_id == "BI" || tipo_categoria_id == "TE" #esto ya no se usa
      return "0102-0140-34000442688-4"
    end
    return "0102-0552-2900-0000-1423"
  end  
  
  def es_su_primer_curso?
    HistorialAcademico.where(:usuario_ci => usuario_ci,
      :idioma_id => idioma_id,
      :tipo_categoria_id => tipo_categoria_id).size == 1
  end
  
  def cuenta_monto
    return tipo_convenio.monto if tipo_convenio.id != "REG"
    return ParametroGeneral.costo_ninos if tipo_categoria_id == "NI"
    return ParametroGeneral.costo_nuevos if tipo_nivel_id == "BI"
    return tipo_convenio.monto
  end
 

  def nivel_anterior(idioma, cat, grado)
    c= Curso.select("curso.tipo_nivel_id").where(["idioma_id = ? AND tipo_categoria_id = ? \
      AND grado = ?",
      idioma, cat, grado-1]).limit(1)

    c.each{|i| 
      return i.tipo_nivel_id
    }

  end


  def aprobados_nivel_anterior(horario, tipo_nivel_anterior, idioma_id, periodo_id, cat)

    #Se buscan todas las secciones del nivel anterior
    secciones_nivel_anterior = Seccion.where(:periodo_id => periodo_id, :idioma_id => idioma_id, :tipo_categoria_id => cat, :tipo_nivel_id => tipo_nivel_anterior, :esta_abierta => 1, :bloque_horario_id => horario).collect{|s| s.seccion_numero}

    #Si no se abrieron secciones para el nivel anterior...
    if(secciones_nivel_anterior.size == 0)

      return 0

    else

      #Se retorna la cantidad de alumnos aprobados que pertenecen a alguna de las secciones del nivel anterior
      return HistorialAcademico.where(["periodo_id = ? AND idioma_id = ? AND tipo_categoria_id = ? AND tipo_nivel_id = ? AND tipo_estado_calificacion_id = ? AND tipo_estado_inscripcion_id = ? AND seccion_numero IN (?)", periodo_id, idioma_id, cat, tipo_nivel_anterior, "AP", "INS", secciones_nivel_anterior]).count

    end



    

  end

end
