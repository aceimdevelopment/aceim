# encoding: utf-8

class ExamenesController < ApplicationController

  before_filter :filtro_logueado
  before_filter :filtro_administrador, :except => ['presentar', 'indicaciones', 'resultado', 'guardar_respuesta', 'completar']
  skip_before_filter  :verify_authenticity_token  

  layout :resolver_layout



  # GET /examenes
  # GET /examenes.json
  def index
    @cursos = Curso.order(['idioma_id', 'grado']).all
    @titulo = "Examentes Listados por Curso"
    @examenes = Examen.order([:curso_idioma_id]).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @examenes }
    end
  end
  
  # GET /examenes/1
  # GET /examenes/1.json
  def show
    @titulo = "Vista Previa del Examen"
    @examen = Examen.find(params[:id])
    @host = "#{request.protocol}#{request.host_with_port}/aceim/assets/examenes/"

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @examen }
    end
  end

  # GET /examenes/new
  # GET /examenes/new.json
  def new


    @titulo = 'Nuevo Examen'
    @examen = Examen.new
    @idiomas = Idioma.all.delete_if{|i| i.id.eql? 'OR'}
    @categorias = TipoCategoria.all.delete_if{|cat| ['BBVA','TR'].include? cat.id}
    @niveles = TipoNivel.where(:id => ['BI','BII','BIII','MI','MII','MIII','AI','AII','AIII', 'CB', 'CI', 'CA'])
    @periodos = Periodo.lista_ordenada

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @examen }
    end
  end

  # GET /examenes/1/edit
  def edit
    @examen = Examen.find(params[:id])
    @idiomas = Idioma.all.delete_if{|i| i.id.eql? 'OR'}
    @categorias = TipoCategoria.all.delete_if{|cat| ['BBVA','TR'].include? cat.id}
    @niveles = TipoNivel.where(:id => ['BI','BII','BIII','MI','MII','MIII','AI','AII','AIII', 'CB', 'CI', 'CA'])
    @periodos = Periodo.lista_ordenada

  end

  # POST /examenes
  # POST /examenes.json
  # def create
  #   @examen = Examen.new(params[:examen])

  #   respond_to do |format|
  #     if @examen.save
  #       format.html { redirect_to @examen, :notice => 'Examen was successfully created.' }
  #       format.json { render :json => @examen, :status => :created, :location => @examen }
  #     else
  #       format.html { render :action => "new" }
  #       format.json { render :json => @examen.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  def create
    @examen = Examen.new(params[:examen])

    respond_to do |format|
      if @examen.save
        exito = 0
         Parte.order('orden ASC').all.each do |parte|
          exito += 1 if @examen.parte_examenes.create(:parte_id => parte.id)  
        end 
        resultado_bloques = "#{exito} Partes del examen añadidas."
        flash[:mensaje] = "Datos básicos almacenados con éxito.#{resultado_bloques}"
        format.html { redirect_to :action => 'wizard_paso2', :id => @examen.id}
        format.json { render :json => @examen, :status => :created, :location => @examen }
      else
        @titulo = "Nueva Examen"
        @accion = "registrar"
        @idiomas = Idioma.all.delete_if{|i| i.id.eql? 'OR'}
        @categorias = TipoCategoria.all.delete_if{|cat| ['BBVA','TR'].include? cat.id}
        @niveles = TipoNivel.where(:id => ['BI','BII','BIII','MI','MII','MIII','AI','AII','AIII'])
        @periodos = Periodo.lista_ordenada    
        flash[:mensaje] = "#{@examen.errors.count} error(es) impiden el registro de la factura: #{@examen.errors.full_messages.join(". ")}."
        format.html { render :action => "new" }
        format.json { render :json => @factura.errors, :status => :unprocessable_entity }
      end
    end

  end




  # PUT /examenes/1
  # PUT /examenes/1.json
  def update
    @examen = Examen.find(params[:id])
    # params[:examen][:tipo_estado_examen_id] = 'PRUEBA' if params[:examen][:tipo_estado_examen_id]
    respond_to do |format|
      if @examen.update_attributes(params[:examen])
        flash[:mensaje] = "Datos editados satisfactoriamente"
        format.html { redirect_to :controller => 'examenes'}
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @examen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /examenes/1
  # DELETE /examenes/1.json
  def destroy
    @examen = Examen.find(params[:id])

    flash[:mensaje] = "Examen Eliminado con éxito" if @examen.destroy   

    respond_to do |format|
      format.html { redirect_to examenes_url }
      format.json { head :ok }
    end
  end

# Funcionalidades adicionales a las CRUD Autogeneradas.

  def wizard_paso2
    id = params[:id]
    @titulo = "Nuevo Examen"
    @examen = Examen.find(id)
    @actividad = Actividad.new

  end

  #Funcion para la generación de EstudianteExamenes tanto para examenes de pruebas como oficiales 
  
  def generar_estudiante_examenes
    @examen = Examen.find params[:id]

    total_cursos = total_est_examen = 0 
    if @examen.es_prueba?
      @curso_periodos = CursoPeriodo.where(:periodo_id => @examen.periodo_id, :idioma_id => @examen.curso_idioma_id)
      total_cursos = @curso_periodos.count

      @curso_periodos.each do |curso_periodo|
        curso_periodo.secciones.each do |seccion|
          seccion.historial_academico.each do |historial|
            total_est_examen += 1 if @examen.estudiante_examenes.create(:estudiante_ci => historial.usuario_ci, :tipo_estado_estudiante_examen_id => 'PREPARADO')
          end
        end
      end

    else
      @curso_periodo = @examen.curso_periodo
      total_cursos = 1
      @curso_periodo.secciones.each do |seccion|
        seccion.historial_academico.each do |historial|
          total_est_examen += 1 if @examen.estudiante_examenes.create(:estudiante_ci => historial.usuario_ci, :tipo_estado_estudiante_examen_id => 'PREPARADO')
        end
      end
    end
    flash[:mensaje] = "#{total_cursos} Curso(s). #{total_est_examen} exámenes generados a estudiantes."
    @examen.tipo_estado_examen_id = 'LISTO'
    flash[:mensaje] += 'Estado del examen actualizado' if @examen.save
    redirect_to :action => 'index'
  end

  def eliminar_etudiante_examenes
    @examen = Examen.find params[:id]

    total = 0
    @examen.estudiante_examenes.each do |ee| 
      ee.estudiante_examen_respuestas.each{|eer| eer.delete}
      total += 1 if ee.delete
    end
    flash[:mensaje] = "#{total} examenes eliminados"
    @examen.tipo_estado_examen_id = 'DISPONIBLE'
    flash[:mensaje] += 'Estado del examen actualizado' if @examen.save
    redirect_to :action => 'index'
  end

  # Avances


  # Funcionalidades CRUD propias de las actividades 

  def registrar_actividad
    @parte_examen = (ParteExamen.where (params[:parte_examen])).limit(1).first

    if @parte_examen

      @actividad = Actividad.new(params[:actividad])
      if @actividad.save and @parte_examen.parte_examen_actividades.create(:actividad_id => @actividad.id)
        flash[:mensaje] = "Actividad agregar con éxito"
      else
        flash[:mensaje] = "No se pudo agregar la actividad. Por favor verifique los campos e intentelo nuevamente."
      end
    else
      flash[:mensaje] = "Falló la inclusión de la nueva actividad, No se encontró la parte del examen requerida. Por Favor Verifique e intentelo nuevamente."
    end
    
    redirect_to :action => 'wizard_paso2', :id => "#{params[:parte_examen][:examen_id]}"
  end

  def actualizar_actividad
    @actividad = Actividad.find(params[:id])
    if @actividad.update_attributes(params[:actividad])
      flash[:mensaje] = "Datos elementales de la actividad actualizados"
    else
      flash[:mensaje] = "No se pudo actualizar los datos de la actividad"
    end
    redirect_to :back
  end

  def eliminar_actividad
    @actividad = Actividad.find(params[:id])
    flash[:mensaje] = "Actividad Eliminada con éxito" if @actividad.destroy

    redirect_to :back
  end

  # Funcionalidades CRUD propias de las preguntas. (Puede trasladarse al controlador apropiado)
  def eliminar_pregunta
    @pregunta = Pregunta.find(params[:id])
    @actividad = @pregunta.actividad
    @pregunta.destroy
    redirect_to :back
      # render :partial => "preguntas/preguntas_text", :locals => {:actividad => @actividad}
  end

  def habilitar_para_presentar
      @estudiante_examen = EstudianteExamen.find params[:id]

      @estudiante_examen.tipo_estado_estudiante_examen_id = 'PREPARADO'
      flash[:mensaje] = "Estado del examen actualizado con exito" if @estudiante_examen.save
      redirect_to :back
  end

# PRESENTAR EXAMENES

  def indicaciones
    # @estudiante_examen = EstudianteExamen.first
    # La linea anterior debe ser sustituida con esta:

    @usuario = session[:usuario]
    @examen_id = params[:id]
    id = "#{@usuario.ci},#{@examen_id}"

    # id = "21121853,#{@examen_id}" if session[:rol].eql? 'Administrador'

    @estudiante_examen = EstudianteExamen.find id
    redirect_to :action => 'index' if @estudiante_examen.blank?

  end

  def presentar
    usuario = session[:usuario]

    @examen = Examen.where(:id => params[:id]).limit(1).first

    if not @examen 

      flash[:mensaje] = 'Examen no encontrado'
      redirect_to :controller => 'principal'
    else

      @estudiante_examen = @examen.estudiante_examenes.where(:estudiante_ci => usuario.ci).limit(1).first

      if @estudiante_examen and @examen.se_puede_presentar? and @estudiante_examen.preparado?
        @estudiante_examen.tipo_estado_estudiante_examen_id = 'INICIADO'
        @estudiante_examen.tiempo = @examen.duracion if @estudiante_examen.tiempo.eql? 0
        @estudiante_examen.save
        # session[:tiempo] = @examen.duracion
        @titulo = @examen.descripcion_simple
        if @examen.prueba and @examen.prueba.eql? true
          @estudiante_examen.estudiante_examen_respuestas.delete_all
        end
        # session[:estudiante_examen] = @estudiante_examen
        session[:estudiante_examen_id] = @estudiante_examen.id
        @estudiante_examen.estado_parte_id = @examen.parte_examenes.first.parte_id
        # @estudiante_examen.save!

        @host = "#{request.protocol}#{request.host_with_port}/aceim/assets/examenes/"
      else
        flash[:mensaje] = 'Examen no disponible'
        redirect_to :controller => 'principal'
      end
    end
  end

  def guardar_respuesta
    eer = params[:eer]
    estudiante_ci = eer[:estudiante_ci]
    examen_id = eer[:examen_id]
    @respuesta_id = eer[:respuesta_id]
    @eer = EstudianteExamenRespuesta.find_or_initialize_by_estudiante_ci_and_examen_id_and_respuesta_id(estudiante_ci,examen_id,@respuesta_id)
    @eer.update_attributes eer

    @eer.estudiante_examen.tiempo = params[:tiempo].to_i + 1
    @eer.estudiante_examen.save
    respond_to do |format|
      format.html {redirect_to :back}
      format.js
    end
    
  end

  def completar
    @estudiante_examen = EstudianteExamen.find session[:estudiante_examen_id].to_s
    @estudiante_examen.tipo_estado_estudiante_examen_id = 'COMPLETADO'
    if @estudiante_examen.save
      session[:estudiante_examen_id] = nil
      flash[:mensaje] = 'Examen Completado con Éxito'
    end

    redirect_to :action => :resultado, :id => @estudiante_examen.id.to_s

  end

  def resultado
    # Variables Globales
    @estudiante_examen = EstudianteExamen.find params[:id].to_s

    @usuario = session[:usuario]

    rol = session[:rol]

    @titulo = "Resultado del examen: #{@estudiante_examen.examen.descripcion}"
    @examen = @estudiante_examen.examen

    @total_actividades = @examen.total_actividades
    @total_preguntas = @examen.total_preguntas
    @total_puntos = @examen.puntaje_total
    
    @total_puntos_correctos = @estudiante_examen.total_puntos_correctos
    @total_respuestas_correctas = @estudiante_examen.total_respuestas_correctas
    @total_respuestas_incorrectas = @total_preguntas - @total_respuestas_correctas

  end

  private

  def resolver_layout
    case action_name
    when 'presentar', 'indicaciones', 'resultado'
      'presentar_examen'
    else
      'application'
    end
  end



end

