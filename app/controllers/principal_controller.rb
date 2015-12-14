class PrincipalController < ApplicationController

  before_filter :filtro_logueado

  def index
    session[:nuevo] = nil 
    @titulo_pagina = "Principal"
    @preinscrito = !!HistorialAcademico.where(
      :usuario_ci => session[:usuario].ci,
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id,
      :periodo_id => session[:parametros][:periodo_inscripcion]).limit(1).first

    @periodo = ParametroGeneral.periodo_actual 
    @ha = HistorialAcademico.where(:idioma_id => session[:tipo_curso].idioma_id, :usuario_ci => session[:usuario].ci, :tipo_categoria_id => 'AD', :periodo_id => @periodo.id).first
    @descargar_planilla_inscripcion = ParametroGeneral.find("DESCARGAR_PLANILLA_INSCRIPCION").valor

    @ha = nil if (@ha and @ha.idioma_id.eql? 'FR' and (@ha.tipo_nivel_id.eql? "CB" or @ha.tipo_nivel_id.eql? "CI" or @ha.tipo_nivel_id.eql? "CA"))

    @curso_abierto_regular = Inscripcion.where(:tipo_inscripcion_id => 'RE', 
      :tipo_estado_inscripcion_curso_id => 'AB', 
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id).limit(1).first

    @curso_abierto_cambio = Inscripcion.where(:tipo_inscripcion_id => 'CA', 
      :tipo_estado_inscripcion_curso_id => 'AB', 
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id).limit(1).first


    @nivelaciones = EstudianteNivelacion.where(
      :usuario_ci => session[:usuario].ci,
      :idioma_id => session[:tipo_curso].idioma_id,
      :tipo_categoria_id => session[:tipo_curso].tipo_categoria_id,
      :periodo_id => session[:parametros][:periodo_inscripcion])
  end

  def principal
    mensaje = flash[:mensaje]
    # flash[:mensaje] = mensaje
    # rol = session[:rol]
    # accion = ""
    # accion = "_admin" if rol == "Administrador"
    # accion = "_instructor" if rol == "Instructor"
    # redirect_to :controller => "principal#{accion}"
    # return
    rol = session[:rol]
    if rol == "Administrador"
      flash[:mensaje] = mensaje
      redirect_to :controller => "principal_admin"
      return
    end
    if rol == "Instructor"
      flash[:mensaje] = mensaje
      redirect_to :controller => "principal_instructor"
      return
    end           
    flash[:mensaje] = mensaje
    redirect_to :controller => "principal"
    return
  end
  
  
  def cambiar_periodo_modal
    @periodos = Periodo.all.collect{|x| x}.sort_by{|x| "#{x.ano} #{x.id}"}.reverse()
    @controlador = params[:parametros][:controlador]
    @accion = params[:parametros][:accion]
    render :layout => false
  end
  
  def cambiar_periodo
    controlador = params[:controlador]
    accion = params[:accion]
    session[:parametros][:periodo_actual] = params[:periodo][:id] 
    flash[:mensaje]= "El periodo fue cambiado a #{session[:parametros][:periodo_actual]}"
    redirect_to :controller => controlador, :action => accion
  end

  
end
