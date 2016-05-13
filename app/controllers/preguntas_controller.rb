# encoding: utf-8

class PreguntasController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador
  skip_before_filter  :verify_authenticity_token  

  # GET /preguntas
  # GET /preguntas.json
  def index
    @preguntas = Pregunta.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @preguntas }
    end
  end

  # GET /preguntas/1
  # GET /preguntas/1.json
  def show
    @pregunta = Pregunta.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @pregunta }
    end
  end

  # GET /preguntas/new
  # GET /preguntas/new.json
  def new
    @pregunta = Pregunta.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @pregunta }
    end
  end

  # GET /preguntas/1/edit
  def edit
    @pregunta = Pregunta.find(params[:id])
  end

  # POST /preguntas
  # POST /preguntas.json
  def create

    if params[:actividad_id]    
      @actividad = actividad.find(params[:actividad_id])
      @pregunta = @actividad.preguntas.create(params[:pregunta])
    else
      @pregunta = Pregunta.new(params[:pregunta])
    end

    respond_to do |format|
      if @pregunta.save
          flash[:mensaje] = 'Pregunta agregada con éxito.'
          format.html { redirect_to :controller => "admin_examenes", :action => "wizard_paso2", :id => @actividad.examen.id}

        # format.html { redirect_to @pregunta, :notice => 'Pregunta was successfully created.' }
        # format.json { render :json => @pregunta, :status => :created, :location => @pregunta }
      else
        format.html { render :action => "new" }
        format.json { render :json => @pregunta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /preguntas/1
  # PUT /preguntas/1.json
  def update
    @pregunta = Pregunta.find(params[:id])

    respond_to do |format|
      if @pregunta.update_attributes(params[:pregunta])
        format.html { redirect_to @pregunta, :notice => 'Pregunta was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @pregunta.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /preguntas/1
  # DELETE /preguntas/1.json
  def destroy
    @pregunta = Pregunta.find(params[:id])
    @pregunta.destroy

    respond_to do |format|
      format.html { redirect_to preguntas_url }
      format.json { head :ok }
    end
  end

  def agregar_sel_multiple
    opciones = params[:opciones]
    # params[:respuesta][:valor] = params[:respuesta][:valor].downcase
    # opciones.each {|op| op.downcase}
    respuesta = params[:respuesta]

    puts "Opciones: <#{opciones.to_s}>"

    puts "Respuesta: #{respuesta[:valor]}"

    esta = false
    # REVISAR LA CREACION DE PREGUNTAS Y RESPUESTAS. VER LA SALIDA CONSOLA (PUT) MENSAJE PARA DETALLES 
    opciones.each{|opc| esta = true if opc.casecmp(respuesta[:valor]).zero?}

    if esta
      valor = params[:pregunta][:valor]
      @pregunta = Pregunta.new(params[:pregunta])
      if @pregunta.save
        flash[:mensaje] = "Pregunta Agregada satisfactoriamente."

        opc_count = 0
        opciones.each do |opc|
          opc_count += 1 if @pregunta.opciones.create(:valor => opc)
        end
        flash[:mensaje] += "#{opc_count} opciones agregadas."
        if @pregunta.respuestas.create(respuesta)
          flash[:mensaje] += "Respuesta correcta agregadas."
        else
          flash[:mensaje] = "Error al intentar cargar la repuesta. Por favor revise los campos e inténtelo nuevamente."
        end

      else
        flash[:mensaje] = "No se pudo agregar la pregunta: #{@pregunta.errors.full_messages.join('-')}."
      end
    else
      flash[:mensaje] = "La respuesta no se encuentra entre las opciones. Por favor verifique la respuesta e inténtelo nuevamente."
    end
    puts "------------------------------------------------------------------------------"
    puts "------------------------------------------------------------------------------"
    puts "------------------------------------------------------------------------------"

    puts "Mensaje: #{flash[:mensaje]}"

    puts "------------------------------------------------------------------------------"
    puts "------------------------------------------------------------------------------"
    puts "------------------------------------------------------------------------------"

    redirect_to :controller => 'admin_examenes', :action => 'wizard_paso2', :id => params[:examen_id]
    # redirect_to :back
  end

end
