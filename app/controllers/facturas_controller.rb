class FacturasController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador

  def index
    @facturas = Factura.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @facturas }
    end
  end

  def detalle
    @factura = Factura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @factura }
    end
  end

  def nueva
    @factura = Factura.new
    @cliente = session[:cliente_id].blank? ? Cliente.new : Cliente.find(session[:cliente_id]) 
    @factura.cliente = @cliente 
    @accion = "registrar"
    @titulo_pagina = "Nueva Factura"
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @factura }
    end
  end


  def editar
    @factura = Factura.find(params[:id])
    @accion = 'actualizar'
    @titulo_pagina = 'Edición de factura'
  end

  def registrar
    @factura = Factura.new(params[:factura])

    respond_to do |format|
      if @factura.save
        flash[:mensaje] = 'Factura registrada'
        format.html { redirect_to :action => 'detalle', :id => @factura.id}
        format.json { render :json => @factura, :status => :created, :location => @factura }
      else
        @titulo_pagina = "Nueva Factura"
        @accion = "registrar"
        flash[:mensaje] = "#{@factura.errors.count} error(es) impiden el registro de la factura: #{@factura.errors.full_messages.join(". ")}."
        format.html { render :action => "nueva" }
        format.json { render :json => @factura.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /facturas/1
  # PUT /facturas/1.json
  def actualizar
    @factura = Factura.find(params[:id])

    respond_to do |format|
      if @factura.update_attributes(params[:factura])
        flash[:mensaje] = 'Factura registrada'
        format.html { redirect_to :action => 'index' , :notice => 'Factura was successfully updated.' }
        format.json { head :ok }
      else
        @titulo_pagina = "Nueva Factura"
        @accion = "actualizar"
        format.html { render :action => "editar" }
        format.json { render :json => @factura.errors, :status => :unprocessable_entity }
      end
    end
  end

  # def eliminar
  #   @factura = Factura.find(params[:id])
  #   @factura.destroy

  #   respond_to do |format|
  #     format.html { redirect_to facturas_url }
  #     format.json { head :ok }
  #   end
  # end
end
