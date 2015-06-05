class InicioController < ApplicationController
  layout "visitante"
  
  def index

		reg = ContenidoWeb.where(:id => 'INI_CONTENT').first
    @content = reg.contenido

    @tipo_inscripciones = TipoInscripcion.all.sort_by{|i| i.descripcion}

    @tipo_cursos = TipoCurso.all.delete_if{|c| c.idioma_id.eql? 'OR' or c.tipo_categoria_id.eql? 'BBVA'}

    # categorias = TipoCurso.where(:inscripcion_abierta =>true).collect{|c| c.tipo_categoria_id}.uniq

    # idiomas = TipoCurso.where(:inscripcion_abierta =>true).collect{|c| c.idioma_id}.uniq

    # periodo_id =  ParametroGeneral.periodo_inscripcion.id

    # secciones = Seccion.where(:periodo_id => periodo_id, :idioma_id => idiomas, :tipo_categoria_id => categorias, :esta_abierta => true).delete_if{|s| !s.hay_cupo?; s.curso.grado != 1}

    # @secciones = Seccion.con_cupo_tipo_curso_abierto_nuevo_perido_actual

    # @tipo_cursos = @secciones.collect{|y| y.tipo_curso}.sort.uniq
    # @secciones = Seccion.secciones_para_inscripciones_cursos_abiertas
    # @cursos_abiertos_nuevo = Inscripcion.where(:tipo_inscripcion_id => 'NU')
    # @cursos_abiertos_nuevo = @secciones.delete_if{|x| x.tipo_curso.inscripcion.tipo_inscripcion_id!='NU'}.collect{|y| y.tipo_curso.inscripcion}.sort.uniq
    # tipo_curso = Seccion.where(:periodo_id => periodo_id,:tipo_categoria_id => categorias).delete_if{|x| x.curso.grado != 1 !(x.hay_cupo?)}.collect{|y| y.tipo_curso.id}.sort.uniq
 
    @cursos_abiertos_nuevo = Inscripcion.where(:tipo_inscripcion_id => 'NU', :tipo_estado_inscripcion_curso_id => 'AB')

    @periodo_inscripcion_id = ParametroGeneral.periodo_inscripcion.id

    # @idiomas = TipoCurso.all.delete_if{|x| !tipo_curso.index(x.id)}

    # if @idiomas.size == 0
    #   flash[:mensaje] = "No hay cursos disponibles"
    #   redirect_to :controller => "inicio"
    #   return
    # end

    # @idiomas_categorias = IdiomaCategoria.all
    # @tipo_cursos = TipoCurso.all.delete_if{|c| c.idioma_id.eql? 'OR'}
  end
  
  def validar  
    unless params[:usuario]
      redirect_to :action => "index"
      return
    end
    login = params[:usuario][:cedula]
    clave = params[:usuario][:clave]     
    reset_session
    #if login == '20028743' || login == '20616058' || login == '20756521'
    #	redirect_to :action => "index"
    #  return
    #end
    if usuario = Usuario.autenticar(login,clave)
      session[:usuario] = usuario
      roles = []
      roles << "Administrador" if usuario.administrador
      roles << "Instructor" if usuario.instructor
      ests = EstudianteCurso.where(:usuario_ci => login) 
      ests.each{ |ec|
        roles << "Estudiante"
      }                       
      if roles.size == 0
        info_bitacora "No tiene roles el usuario #{login}"
        flash[:mensaje_login] = "Usuario sin rol"
        redirect_to :action => "index"          
        return
      elsif roles.size == 1 
        cargar_parametros_generales   
        redirect_to :action => "un_rol", :tipo => roles.first
        return
      else   
        info_bitacora "Tiene mas de un rol el usuario #{login}"
        cargar_parametros_generales   
        flash[:mensaje] = "Usted tiene más de un rol, debe seleccionar un rol"
        redirect_to :action => "seleccionar_rol"
        return
      end
    end           
    info_bitacora "Error en el login o clave #{login}"
    flash[:mensaje_login] = "Error en login o clave"
    redirect_to :action => "index"
  end  
  
  def seleccionar_rol    
    usuario = session[:usuario]
    @roles = []
    @roles << { :tipo => "Administrador", :descripcion => "Administrador"} if usuario.administrador
    @roles << { :tipo => "Instructor", :descripcion => "Instructor"} if usuario.instructor
    usuario.estudiante_curso.each{|ec|
      @roles << { 
        :tipo => "Estudiante",
        :descripcion => ec.descripcion,
        :tipo_categoria_id => ec.tipo_categoria_id,
        :idioma_id => ec.idioma_id
      }  
    }                                             
  end 
  
  def un_rol 
    tipo = params[:tipo]
    usuario = session[:usuario]
    if tipo ==  "Administrador" && usuario.administrador
      session[:rol] = tipo
      session[:administrador] = usuario.administrador 
      info_bitacora "Inicio de sesion del adminitrador"
      redirect_to :controller => "principal_admin"
      return
    elsif tipo ==  "Instructor" && usuario.instructor
      session[:rol] = tipo
      session[:instructor] = usuario.instructor 
      info_bitacora "Inicio de sesion del instructor"
      redirect_to :controller => "principal_instructor"
      return  
    elsif tipo ==  "Estudiante"
      ec = nil
      if params[:tipo_categoria_id] && params[:idioma_id]
        ec = EstudianteCurso.where(
          :usuario_ci => usuario.ci,
          :tipo_categoria_id => params[:tipo_categoria_id],
          :idioma_id => params[:idioma_id]).limit(1).first
      else
        ec = EstudianteCurso.where(
          :usuario_ci => usuario.ci).limit(1).first
      end
      if ec      
        session[:estudiante] = usuario.estudiante
        session[:rol] = ec.descripcion
        session[:tipo_curso] = ec.tipo_curso  
        info_bitacora "Inicio de sesion del estudiante"
        redirect_to :controller => "principal"
        return
      end
    end
    flash[:mensaje_login] = "Inicio inválido"
    redirect_to :action => "index"
    return
  end
  
  def cerrar_sesion
    reset_session
    redirect_to :action => "index", :controller => "inicio"
  end 
  
  def autenticacion_nuevo
    #redirect_to :action => "paso0", :controller => "inscripcion"
  end
  
  def validar_nuevo
    unless params[:usuario]
      redirect_to :action => "index"
      return
    end
    usuario = params[:usuario][:usuario]
    clave = params[:usuario][:clave]   
    
    if usuario == "new" && clave == "coursesa12" || usuario == "invitado" && clave == "invitado"
      redirect_to :action => "paso0", :controller => "inscripcion"
    else
      flash[:mensaje] = "Datos Inválidos"
      redirect_to :action => "autenticacion_nuevo"
    end
  end

  def olvido_clave_guardar
    cedula = params[:usuario][:ci]
    usuario = Usuario.where(:ci => cedula).limit(0).first
    if usuario
      EstudianteMailer.olvido_clave(usuario).deliver  
      info_bitacora "El usuario #{usuario.descripcion} olvido su clave y la pidio recuperar"
      flash[:mensaje] = "Se ha enviado la clave al correo: #{usuario.correo}"
      redirect_to :action => :index
    else
      flash[:mensaje] = "Usuario no registrado"
      redirect_to :action => :olvido_clave
    end
    
  end

end
