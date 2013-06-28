class InscripcionController < ApplicationController
  
  #before_filter :filtro_inscripcion_abierta, :except => ["paso0","paso0_guardar","planilla_inscripcion"] 
  #before_filter :filtro_primer_dia, :only => ["paso1","paso2"]
  before_filter :filtro_logueado, :except => ["paso0","paso0_guardar"]
  #before_filter :filtro_nuevos
  
  def paso0                    
    reset_session
    cargar_parametros_generales
    @titulo_pagina = "Inscripción de Nuevo en Idioma"  
    @subtitulo_pagina = "Datos Básicos"    
    @usuario = Usuario.new                    
    categorias = []
    categorias << "NI" if ParametroGeneral.inscripcion_ninos_abierta
    categorias << "AD" if ParametroGeneral.inscripcion_nuevos_abierta
    categorias << "TE" if ParametroGeneral.inscripcion_nuevos_abierta
    tipo_curso = Seccion.where(:periodo_id => session[:parametros][:periodo_inscripcion],
      :tipo_categoria_id => categorias).delete_if{|x|
      x.curso.grado != 1
      }.collect{|y| y.tipo_curso.id}.sort.uniq                                          
    #puts tipo_curso.inspect
    #if session[:parametros][:inscripcion_modo_ninos] == "SI"
    #tipo_curso = Seccion.where(:periodo_id => session[:parametros][:periodo_inscripcion], :tipo_categoria_id => "NI").delete_if{|x|
    #  x.curso.grado != 1
    #  }.collect{|y| y.tipo_curso.id}.sort.uniq
    #end
    #puts tipo_curso.inspect
    #puts session.inspect
    @idiomas = TipoCurso.all.delete_if{|x| !tipo_curso.index(x.id)}
    if @idiomas.size == 0
      flash[:mensaje] = "No hay cursos disponibles"
      redirect_to :controller => "inicio"
      return
    end
    render :layout => "nuevo"
  end
  
  def paso0_guardar
    session[:nuevo] = true
    usuario_ci = params[:usuario][:ci]
    idioma_id, tipo_categoria_id = params[:seleccion][:idioma_id].split","
    
    @tipo_curso = TipoCurso.where(
       :idioma_id => idioma_id,
       :tipo_categoria_id => tipo_categoria_id).limit(1).first
    #buscar en usuario
    if usuario = Usuario.where(:ci => usuario_ci).limit(1).first
      @usuario = usuario      
      
      if estudiante = Estudiante.where(:usuario_ci => usuario_ci).limit(1).first
        @estudiante = estudiante           
        
        if ec = EstudianteCurso.where(:usuario_ci => usuario_ci,
           :idioma_id => idioma_id,
           :tipo_categoria_id => tipo_categoria_id).limit(1).first
          @estudiante_curso = ec
        else
          @estudiante_curso = EstudianteCurso.new
          @estudiante_curso.usuario_ci = usuario_ci
          @estudiante_curso.idioma_id = idioma_id
          @estudiante_curso.tipo_categoria_id = tipo_categoria_id
          @estudiante_curso.tipo_convenio_id = "REG"
          @estudiante_curso.save!
        end
      else
        @estudiante = Estudiante.new
        @estudiante.usuario_ci = usuario_ci
        @estudiante.save!

        @estudiante_curso = EstudianteCurso.new
        @estudiante_curso.usuario_ci = usuario_ci
        @estudiante_curso.idioma_id = idioma_id
        @estudiante_curso.tipo_categoria_id = tipo_categoria_id
        @estudiante_curso.tipo_convenio_id = "REG"
        @estudiante_curso.save!
      end
    else
      @usuario = Usuario.new
      @usuario.ci = usuario_ci
      @usuario.nombres = ""
      @usuario.apellidos = ""
      @usuario.telefono_movil = ""
      @usuario.fecha_nacimiento = "1990-01-01"
      @usuario.save! :validate => false

      @estudiante = Estudiante.new
      @estudiante.usuario_ci = usuario_ci
      @estudiante.save!

      @estudiante_curso = EstudianteCurso.new
      @estudiante_curso.usuario_ci = usuario_ci
      @estudiante_curso.idioma_id = idioma_id
      @estudiante_curso.tipo_categoria_id = tipo_categoria_id
      @estudiante_curso.tipo_convenio_id = "REG"
      @estudiante_curso.save!


    end
    session[:usuario] = @usuario
    session[:estudiante] = @estudiante
    session[:rol] = @estudiante_curso.descripcion
    session[:tipo_curso] = @tipo_curso
    info_bitacora "Paso 0 realizado en #{@tipo_curso.descripcion}"
    redirect_to :action => "paso1"
    return
  end

  def paso1      
    @titulo_pagina = "Preinscripción - Paso 1 de 3"  
    @subtitulo_pagina = "Actualización de Datos Personales"
    @usuario = session[:usuario]
  end  

  def paso1_guardar
    usr = params[:usuario]
    if @usuario = Usuario.where(:ci => usr[:ci]).limit(1).first
      @usuario.ultima_modificacion_sistema = Time.now
      @usuario.nombres = usr[:nombres]
      @usuario.apellidos = usr[:apellidos]
      @usuario.correo = usr[:correo]
      @usuario.tipo_sexo_id = usr[:tipo_sexo_id]
      @usuario.telefono_movil = usr[:telefono_movil]
      
      if session[:nuevo]
        @usuario.telefono_habitacion = ""
        @usuario.direccion = ""
        @usuario.contrasena = usr[:ci]
        @usuario.contrasena_confirmation = usr[:ci]
        @usuario.fecha_nacimiento = "1990-01-01"
        @usuario.fecha_nacimiento = usr[:fecha_nacimiento]
      else
        @usuario.telefono_movil = usr[:telefono_movil]
        @usuario.telefono_habitacion = usr[:telefono_habitacion]
        @usuario.direccion = usr[:direccion]
        @usuario.contrasena = usr[:contrasena]
        @usuario.contrasena_confirmation = usr[:contrasena_confirmation]
        @usuario.fecha_nacimiento = usr[:fecha_nacimiento]
      end
      
      session[:usuario] = @usuario
      
      if (@usuario.edad < 9 || @usuario.edad > 11) && session[:tipo_curso].tipo_categoria_id == "NI" #&& session[:nuevo]
        flash[:mensaje] = "Usted no tiene la edad para el curso de niños"
        redirect_to :action => "paso1"
        return
      end

      if (@usuario.edad < 12 || @usuario.edad > 14) && session[:tipo_curso].tipo_categoria_id == "TE" #&& session[:nuevo]
        flash[:mensaje] = "Usted no tiene la edad para el curso de adolecentes"
        redirect_to :action => "paso1"
        return
      end

      if (@usuario.edad < 15 ) && session[:tipo_curso].tipo_categoria_id == "AD" #&& session[:nuevo]
        flash[:mensaje] = "Usted no tiene la edad para el curso de adultos"
        redirect_to :action => "paso1"
        return
      end
      
      if @usuario.save 
        info_bitacora "Paso1 realizado"
        redirect_to :action => "paso2"
      else
        @titulo_pagina = "Preinscripción - Paso 1 de 3"  
        @subtitulo_pagina = "Actualización de Datos Personales"
        render :action => "paso1"
      end
    else
      flash[:mensaje] = "Error Usuario no encontrado #{usr[:ci]}"
      render :action => "paso1"
    end
  end

  def paso2
    @titulo_pagina = "Preinscripción - Paso 2 de 3"
    @subtitulo_pagina = "Selección de Horario"

    ec = EstudianteCurso.find(session[:usuario], 
      session[:tipo_curso].idioma_id, 
      session[:tipo_curso].tipo_categoria_id)
     

    

    @historial = nil
    begin
      @historial = ec.proximo_historial
    rescue Exception => e
      flash[:mensaje] = e.message
      redirect_to :controller => "principal", :action => "principal"
      return
    end

    if @historial.tipo_nivel_id == "BI" 
      if !ParametroGeneral.inscripcion_nuevos_abierta 
        flash[:mensaje] = "En este momento no estan abiertas las inscripciones para básico I"
        redirect_to :controller => "principal", :action => "principal"
        return
      end
    end

    if @historial
      @horarios = @historial.horarios_disponibles(
        session[:parametros][:inscripcion_permitir_cambio_horario] == "NO"
      )              
      if @horarios.size == 0
        flash[:mensaje] = "En este momento no tenemos cupos."
        redirect_to :controller => "principal", :action => "principal"
        return
      end
      session[:seccion] = @historial.seccion_numero
    else # le toca nuevo
      flash[:mensaje] = "Error con el estudiante y su curso"
      redirect_to :controller => "principal", :action => "principal"
      return
    end
  end

  def paso2_guardar 

    seccion = session[:seccion]  
    
    ec = EstudianteCurso.find(session[:usuario], 
    session[:tipo_curso].idioma_id, 
    session[:tipo_curso].tipo_categoria_id)
    
    @historial = ec.proximo_historial
    
    seccion = @historial.buscar_seccion(params[:usuario][:horario]) unless seccion
    unless seccion 
      flash[:mensaje] = "Lo sentimos pero no hay secciones disponibles en ese horario"
      info_bitacora "No hay secciones disponible para su horario"
      redirect_to :action => "paso2"
      return
    end
    @historial.seccion_numero = seccion
    
    if HistorialAcademico.where(
      :usuario_ci => @historial.usuario_ci,
      :idioma_id => @historial.idioma_id,
      :tipo_categoria_id => @historial.tipo_categoria_id,
      :periodo_id => @historial.periodo_id
      ).limit(1).first
      flash[:mensaje] = "Usted ya estaba inscrito en este periodo"
      info_bitacora "Usuario ya estaba inscrito en este periodo"
      redirect_to :action => "principal", :controller => "principal"
      return
    end
    
    @historial.save  
    info_bitacora "Paso 2 realizado preinscripcion realizada en #{@historial.seccion.descripcion_con_periodo}"
    flash[:mensaje] = "Preinscripción realizada, recuerde imprimir su planilla"
    redirect_to :action => "paso3"
  end

  def paso3 
    @titulo_pagina = "Preinscripción - Paso 3 de 3"  
    @subtitulo_pagina = "Impresión de Planilla"
    @historial = HistorialAcademico.where(
      :usuario_ci => session[:usuario].ci,
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id,
      :periodo_id => session[:parametros][:periodo_inscripcion]).limit(1).first
  end

  def paso3_guardar                                              
    flash[:mensaje] = "Preinscripción finalizada"
    redirect_to :action => "principal", :controller => "principal"
  end     
  
  def planilla_inscripcion
    @historial = HistorialAcademico.where(
      :usuario_ci => session[:usuario].ci,
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id,
      :periodo_id => session[:parametros][:periodo_inscripcion]).limit(1).first
    info_bitacora "Se busco la planilla de inscripcion en #{@historial.seccion.descripcion_con_periodo}"
    pdf = DocumentosPDF.planilla_inscripcion(@historial)
    send_data pdf.render,:filename => "planilla_inscripcion_#{session[:usuario].ci}.pdf",
                         :type => "application/pdf", :disposition => "attachment"
  end
  
  def comprobante
    render :layout => false
  end

end
