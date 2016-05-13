# encoding: utf-8

class TextosController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador
  skip_before_filter  :verify_authenticity_token  

  def create
    @actividad = Actividad.find(params[:actividad_id])

    respond_to do |format|
      if @actividad and @actividad.textos.create(params[:texto])
        flash[:mensaje] = 'Texto agregado con éxito.'

        # format.html { redirect_to @pregunta, :notice => 'Pregunta was successfully created.' }
        # format.json { render :json => @pregunta, :status => :created, :location => @pregunta }
      else
        flash[:mensaje] = 'Texto agregado con éxito.'
        # format.html { render :action => "new" }
        # format.json { render :json => @texto.errors, :status => :unprocessable_entity }
      end
      format.html { redirect_to :controller => "admin_examenes", :action => "wizard_paso2", :id => params[:examen_id]}
    end
  end

end