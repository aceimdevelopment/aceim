class InscripcionController < ApplicationController
  
  #before_filter :filtro_inscripcion_abierta, :except => ["paso0","paso0_guardar","planilla_inscripcion"] 
  #before_filter :filtro_primer_dia, :only => ["paso1","paso2"]
  before_filter :filtro_logueado, :except => ["paso0_ingles", "paso0","paso0_guardar", 'ingrese_ci', 'ingrese_ci_guardar']
  #before_filter :filtro_nuevos


  # def paso0_ingles
  #   reset_session
  #   cargar_parametros_generales
  #   if ParametroGeneral.inscripcion_abierta_ingles_adulto
  #     redirect_to root
  #   else
  #     @titulo_pagina = "Inscripción de Nuevo en Inglés"  
  #     @subtitulo_pagina = "Datos Básicos"
  #     @usuario = Usuario.new

  #   tipo_curso = Seccion.where(:periodo_id => session[:parametros][:periodo_inscripcion],
  #     :tipo_categoria_id => 'AD', :idioma_id => 'IN').delete_if{|x|
  #     x.curso.grado != 1
  #     }.collect{|y| y.tipo_curso.id}.sort.uniq
  #   end

  #   tipo_curso = Seccion.where(:periodo_id => 'B-2015', :idioma_id => 'IN', :tipo_nivel_id => 'BI').collect{|y| y.tipo_curso.id}.sort.uniq
    
  # end

  def ingrese_ci
    reset_session
    cargar_parametros_generales    
    @tipo_curso = TipoCurso.find(params[:id])
    unless @tipo_curso && @tipo_curso.inscripcion_abierta
      reset_session
      session[:flash] = "Error, No hay cursos abiertos para el idioma y categoria solicitado"
      rediret_to "index"
    else
      session[:tipo_curso] = @tipo_curso

      @titulo_pagina = "Inscripción de Curso #{@tipo_curso.descripcion}"  
      @subtitulo_pagina = "Paso 1: Registro de Cédula de Identidad"
    end
    render :layout => "nuevo"
  end

  def ingrese_ci_guardar
    usuario_ci = params[:usuario][:ci].delete(" ")

    tipo_curso = session[:tipo_curso]

    if tipo_curso.nil? or (tipo_curso.inscripcion_abierta.eql? false) or tipo_curso.nil?
      reset_session
      session[:flash] = "Error, No hay cursos abiertos para el idioma y categoria solicitado"
      rediret_to "index"
    end
    # Si hay idioma_categoria y TipoCurso correspondiente:
    # procedemos a localizar el usuario o a crearlo si no existe
    unless usuario = Usuario.where(:ci => usuario_ci).limit(1).first
      usuario = Usuario.new
      usuario.ci = usuario_ci
      usuario.nombres = usuario.apellidos = usuario.telefono_movil = ""
      usuario.fecha_nacimiento = "1990-01-01"
      usuario.save! :validate => false
    end

    # procedemos a localizar o crear el estudiante
    unless est = usuario.estudiante
      # Estudiante.create(:usuario_ci => usuario.ci, :tipo_nivel_academico_id => nil) 
      est = Estudiante.new
      est.usuario_ci = usuario_ci
      est.save!
    end

    unless estudiante_curso = est.estudiante_cursos.where(:idioma_id => tipo_curso.idioma_id, :tipo_categoria_id => tipo_curso.tipo_categoria_id).limit(1).first
      estudiante_curso = EstudianteCurso.new
      estudiante_curso.usuario_ci = usuario_ci
      estudiante_curso.idioma_id = tipo_curso.idioma_id
      estudiante_curso.tipo_categoria_id = tipo_curso.tipo_categoria_id
      estudiante_curso.tipo_convenio_id = "REG"
      estudiante_curso.save!
    end

    session[:usuario] = usuario
    # session[:estudiante] = est
    # session[:rol] = estudiante_curso.descripcion
    info_bitacora "Preinscripción: Paso 0 realizado en #{tipo_curso.descripcion}"

    redirect_to :action => "seleccionar_horario"
    return

  end

  def seleccionar_horario
    tipo_curso = session[:tipo_curso]
    periodo_id =  ParametroGeneral.periodo_inscripcion.id

    secciones = Seccion.where(:periodo_id => periodo_id, :idioma_id => tipo_curso.idioma_id, :tipo_categoria_id => tipo_curso.tipo_categoria_id, :esta_abierta => true).delete_if{|s| s.curso.grado != 1}.delete_if{|s| !s.hay_cupo?} 
    @horarios = secciones.collect{|s| s.horario}.uniq

    @titulo_pagina = "Inscripción de Curso #{tipo_curso.descripcion}"  
    @subtitulo_pagina = "Paso 2: Selección de horario"



    # @titulo_pagina = "Preinscripción - Paso 1 de 3"
    # @subtitulo_pagina = "Selección de Horario"

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

    # if @historial.tipo_nivel_id == "BI" 
    #   if !ParametroGeneral.inscripcion_nuevos_abierta 
    #     flash[:mensaje] = "En este momento no estan abiertas las inscripciones para básico I"
    #     redirect_to :controller => "principal", :action => "principal"
    #     return
    #   end
    # end

    # if @historial
    #   @horarios = @historial.horarios_disponibles(
    #     session[:parametros][:inscripcion_permitir_cambio_horario] == "NO"
    #   )              
    #   if @horarios.size == 0
    #     flash[:mensaje] = "En este momento no tenemos cupos."
    #     redirect_to :controller => "principal", :action => "principal"
    #     return
    #   end
    #   session[:seccion] = @historial.seccion_numero
    # else # le toca nuevo
    #   flash[:mensaje] = "Error con el estudiante y su curso"
    #   redirect_to :controller => "principal", :action => "principal"
    #   return
    # end


  end


  def seleccionar_horario_guardar

    seccion = session[:seccion]  
    
    ec = EstudianteCurso.find(session[:usuario], 
    session[:tipo_curso].idioma_id, 
    session[:tipo_curso].tipo_categoria_id)
    
    @historial = ec.proximo_historial
    
    seccion = @historial.buscar_seccion(params[:usuario][:horario]) unless seccion
    unless seccion 
      flash[:mensaje] = "Lo sentimos pero no hay secciones disponibles en ese horario"
      info_bitacora "No hay secciones disponible para su horario"
      redirect_to :action => "seleccionar_horario"
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
    info_bitacora "Paso 1 realizado preinscripcion realizada en #{@historial.seccion.descripcion_con_periodo}"
    flash[:mensaje] = "Preinscripción realizada, Su cupo está reservado"
    redirect_to :action => "actualizar_datos_personales"
    
  end

  def actualizar_datos_personales
    @titulo_pagina = "Preinscripción - Paso 2 de 3"  
    @subtitulo_pagina = "Actualización de Datos Personales"
    @usuario = session[:usuario]
  end


  def guardar_datos_personales
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
        redirect_to :action => "actualizar_datos_personales"
        return
      end

      if (@usuario.edad < 12 || @usuario.edad > 14) && session[:tipo_curso].tipo_categoria_id == "TE" #&& session[:nuevo]
        flash[:mensaje] = "Usted no tiene la edad para el curso de adolecentes"
        redirect_to :action => "actualizar_datos_personales"
        return
      end

      if (@usuario.edad < 15 ) && session[:tipo_curso].tipo_categoria_id == "AD" #&& session[:nuevo]
        flash[:mensaje] = "Usted no tiene la edad para el curso de adultos"
        redirect_to :action => "actualizar_datos_personales"
        return
      end
      
      if @usuario.save 
        info_bitacora "Paso2 realizado"
        flash[:mensaje] = "Preinscripción realizada, recuerde imprimir su planilla"
        redirect_to :action => "imprimir_planilla"
      else
        @titulo_pagina = "Preinscripción - Paso 2 de 3"  
        @subtitulo_pagina = "Actualización de Datos Personales"
        render :action => "actualizar_datos_personales"
      end
    else
      flash[:mensaje] = "Error Usuario no encontrado #{usr[:ci]}"
      render :action => "actualizar_datos_personales"
    end    
  end

  def imprimir_planilla
    @titulo_pagina = "Preinscripción - Paso 3 de 3"  
    @subtitulo_pagina = "Impresión de Planilla"
    @historial = HistorialAcademico.where(
      :usuario_ci => session[:usuario].ci,
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id,
      :periodo_id => session[:parametros][:periodo_inscripcion]).limit(1).first    
  end


  def finalizar_inscripcion
    flash[:mensaje] = "Preinscripción finalizada"
    redirect_to :action => "principal", :controller => "principal"
  end



  def paso0                    
    reset_session
    cargar_parametros_generales
    @titulo_pagina = "Inscripción de Nuevo en Idioma"  
    @subtitulo_pagina = "Datos Básicos"    
    @usuario = Usuario.new                    
    categorias = []
    categorias << "NI" if ParametroGeneral.inscripcion_ninos_abierta
    # comentar esta siguoiente linea cuando este lista la inscripcion de ingles adultos
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

  def paso1_guardar

    seccion = session[:seccion]  
    
    ec = EstudianteCurso.find(session[:usuario], 
    session[:tipo_curso].idioma_id, 
    session[:tipo_curso].tipo_categoria_id)
    
    @historial = ec.proximo_historial
    
    seccion = @historial.buscar_seccion(params[:usuario][:horario]) unless seccion
    unless seccion 
      flash[:mensaje] = "Lo sentimos pero no hay secciones disponibles en ese horario"
      info_bitacora "No hay secciones disponible para su horario"
      redirect_to :action => "paso1"
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
    info_bitacora "Paso 1 realizado preinscripcion realizada en #{@historial.seccion.descripcion_con_periodo}"
    flash[:mensaje] = "Preinscripción realizada, Su cupo está reservado"
    redirect_to :action => "paso2"
  end


  def paso2      
    @titulo_pagina = "Preinscripción - Paso 2 de 3"  
    @subtitulo_pagina = "Actualización de Datos Personales"
    @usuario = session[:usuario]
  end  

  def paso2_guardar
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
        redirect_to :action => "paso2"
        return
      end

      if (@usuario.edad < 12 || @usuario.edad > 14) && session[:tipo_curso].tipo_categoria_id == "TE" #&& session[:nuevo]
        flash[:mensaje] = "Usted no tiene la edad para el curso de adolecentes"
        redirect_to :action => "paso2"
        return
      end

      if (@usuario.edad < 15 ) && session[:tipo_curso].tipo_categoria_id == "AD" #&& session[:nuevo]
        flash[:mensaje] = "Usted no tiene la edad para el curso de adultos"
        redirect_to :action => "paso2"
        return
      end
      
      if @usuario.save 
        info_bitacora "Paso2 realizado"
        flash[:mensaje] = "Preinscripción realizada, recuerde imprimir su planilla"
        redirect_to :action => "paso3"
      else
        @titulo_pagina = "Preinscripción - Paso 2 de 3"  
        @subtitulo_pagina = "Actualización de Datos Personales"
        render :action => "paso2"
      end
    else
      flash[:mensaje] = "Error Usuario no encontrado #{usr[:ci]}"
      render :action => "paso2"
    end
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
