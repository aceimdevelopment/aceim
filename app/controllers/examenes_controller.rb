class ExamenesController < ApplicationController

  before_filter :filtro_logueado
  before_filter :filtro_administrador
  skip_before_filter  :verify_authenticity_token  

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
    @examen = Examen.new

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
    @niveles = TipoNivel.where(:id => ['BI','BII','BIII','MI','MII','MIII','AI','AII','AIII'])
    @periodos = Periodo.lista_ordenada

  end

  # POST /examenes
  # POST /examenes.json
  def create
    @examen = Examen.new(params[:examen])

    respond_to do |format|
      if @examen.save
        format.html { redirect_to @examen, :notice => 'Examen was successfully created.' }
        format.json { render :json => @examen, :status => :created, :location => @examen }
      else
        format.html { render :action => "new" }
        format.json { render :json => @examen.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /examenes/1
  # PUT /examenes/1.json
  def update
    @examen = Examen.find(params[:id])
    params[:examen][:tipo_estado_examen_id] = 'PRUEBA' if params[:examen][:tipo_estado_examen_id]
    respond_to do |format|
      if @examen.update_attributes(params[:examen])
        flash[:mensaje] = "Datos editados satisfactoriamente"
        format.html { redirect_to :controller => 'admin_examenes'}
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
    @examen.destroy

    respond_to do |format|
      format.html { redirect_to examenes_url }
      format.json { head :ok }
    end
  end

  def wizard_paso2
    id = params[:id]
    @titulo = "Nuevo Examen"
    @examen = Examen.find(id)
    @actividad = Actividad.new

  end

end
