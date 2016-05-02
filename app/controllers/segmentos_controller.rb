class SegmentosController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador
  skip_before_filter  :verify_authenticity_token  

  # GET /segmentos
  # GET /segmentos.json
  def index
    @segmentos = Segmento.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @segmentos }
    end
  end

  # GET /segmentos/1
  # GET /segmentos/1.json
  def show
    @segmento = Segmento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @segmento }
    end
  end

  # GET /segmentos/new
  # GET /segmentos/new.json
  def new
    @segmento = Segmento.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @segmento }
    end
  end

  # GET /segmentos/1/edit
  def edit
    @segmento = Segmento.find(params[:id])
  end

  # POST /segmentos
  # POST /segmentos.json
  def create
    if params[:examen_id]
      @examen = Examen.find(params[:examen_id])
      @segmento = @examen.segmentos.create(params[:segmento])
    else
      @segmento = Segmento.new(params[:segmento])      
    end
    respond_to do |format|
      if @segmento.save
        # if params[:examen_id]
          flash[:mensaje] = 'Actividad creado con éxito.'
          format.html { redirect_to :controller => "admin_examenes", :action => "wizard_paso2", :id => @examen.id}
        # else
          # format.html { redirect_to examen_path(@examen), :notice => 'Segmento was successfully created.' }          

          format.json { render :json => @examen, :status => :created, :location => @examen }
      else
        # accion = params[:examen_id] ? "admin_examenes/wizard_paso2/#{@examen.id}" : 'new'
        format.html { render :action => 'new' }
        format.json { render :json => @segmento.errors, :status => :unprocessable_entity }
      end
    end
  end


  # PUT /segmentos/1
  # PUT /segmentos/1.json
  def update
    @segmento = Segmento.find(params[:id])

    respond_to do |format|
      if @segmento.update_attributes(params[:segmento])
        format.html { redirect_to @segmento, :notice => 'Segmento was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @segmento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /segmentos/1
  # DELETE /segmentos/1.json
  def destroy
    @segmento = Segmento.find(params[:id])
    @segmento.destroy

    respond_to do |format|
      format.html { redirect_to segmentos_url }
      format.json { head :ok }
    end
  end
end
