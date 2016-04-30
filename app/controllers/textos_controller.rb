class TextosController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador
  skip_before_filter  :verify_authenticity_token  

  def create
    if params[:segmento_id]    
      @segmento = Segmento.find(params[:segmento_id])
      @texto = @segmento.textos.create(params[:texto])
    else
      @texto = Pregunta.new(params[:texto])
    end

    respond_to do |format|
      if @texto.save
              flash[:mensaje] = 'Texto agregado con éxito.'
          format.html { redirect_to :controller => "admin_examenes", :action => "wizard_paso2", :id => @segmento.examen.id}

        # format.html { redirect_to @pregunta, :notice => 'Pregunta was successfully created.' }
        # format.json { render :json => @pregunta, :status => :created, :location => @pregunta }
      else
        format.html { render :action => "new" }
        format.json { render :json => @texto.errors, :status => :unprocessable_entity }
      end
    end
  end

end