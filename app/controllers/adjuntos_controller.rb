class AdjuntosController < ApplicationController
  # GET /adjuntos
  # GET /adjuntos.json

  before_filter :filtro_logueado
  before_filter :filtro_administrador
  skip_before_filter  :verify_authenticity_token  

  def index
    @adjuntos = Adjunto.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adjuntos }
    end
  end

  # GET /adjuntos/1
  # GET /adjuntos/1.json
  def show
    @adjunto = Adjunto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @adjunto }
    end
  end

  # GET /adjuntos/new
  # GET /adjuntos/new.json
  def new
    @adjunto = Adjunto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @adjunto }
    end
  end

  # GET /adjuntos/1/edit
  def edit
    @adjunto = Adjunto.find(params[:id])
  end

  # POST /adjuntos
  # POST /adjuntos.json
  def create
    @adjunto = Adjunto.new(params[:adjunto])

    respond_to do |format|
      if @adjunto.save
        format.html { redirect_to @adjunto, notice: 'Adjunto was successfully created.' }
        format.json { render json: @adjunto, status: :created, location: @adjunto }
      else
        format.html { render action: "new" }
        format.json { render json: @adjunto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adjuntos/1
  # PUT /adjuntos/1.json
  def update
    @adjunto = Adjunto.find(params[:id])

    respond_to do |format|
      if @adjunto.update_attributes(params[:adjunto])
        format.html { redirect_to @adjunto, notice: 'Adjunto was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @adjunto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adjuntos/1
  # DELETE /adjuntos/1.json
  def destroy
    @adjunto = Adjunto.find(params[:id])
    archivo = "#{Rails.root}/app/assets/images/examenes/#{@adjunto.archivo}"
    begin
      File.delete(archivo)
      flash[:mensaje] = "Archivo Eliminado del sistema."
      @adjunto.destroy
    rescue Exception => e
      flash[:mensaje] = "Error al intentar eliminar. #{e.message}"
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
    end
  end

  def eliminar_archivo
    @adjunto = Adjunto.find(params[:id])
    archivo = "#{Rails.root}/app/assets/images/examenes/#{@adjunto.nombre}"
    begin
      File.delete(archivo)
      flash[:mensaje] = "Archivo Eliminado del sistema."
      @adjunto.destroy
    rescue Exception => e
      flash[:mensaje] = "Error al intentar eliminar. #{e.message}"
    end
    
    redirect_to :controller => "admin_examenes", :action => "wizard_paso2", :id => params[:examen_id]
  end

  def importar_archivo

    begin
      data = params[:archivo][:datafile]
      nombre = data.original_filename
      nombre = "#{params[:actividad_id]}_#{nombre}"
      archivo = "#{Rails.root}/app/assets/images/examenes/#{nombre}"
      data = data.tempfile
      @adjunto = Adjunto.new

      @adjunto.archivo = nombre
      @adjunto.actividad_id = params[:actividad_id]

      File.open("#{archivo}", "wb") {|file| file.write data.read}
      flash[:mensaje] = "Archivo guardado."
      flash[:mensaje] += "Adjunto agregado." if @adjunto.save
    rescue Exception => e
      flash[:mensaje] = "Error: #{e.message}"
    end
    redirect_to :controller => "admin_examenes", :action => "wizard_paso2", :id => params[:examen_id]
  end

end
