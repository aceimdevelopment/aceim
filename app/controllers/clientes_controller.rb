class ClientesController < ApplicationController
  before_filter :filtro_logueado
  before_filter :filtro_administrador

  def index
    @clientes = Cliente.all
    @titulo_pagina = "Lista de clientes"
    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @clientes }
    end
  end

  def ver
    @cliente = Cliente.find(params[:id])
    respond_to do |format|
      format.json { render :json => @cliente}
    end
    return
  end

  def nuevo
    @cliente = Cliente.new
    @titulo_pagina = "Nuevo Cliente"
    @accion = "registrar"
    render :layout => false 
  end


  def editar
    @accion = "actualizar"
    @titulo_pagina = "Edicción de Cliente"
    @cliente = Cliente.find(params[:id])
  end


  def registrar
    @cliente = Cliente.new(params[:cliente])

    respond_to do |format|
      if @cliente.save
        flash[:mensaje] = 'Cliente registrado'
        session[:cliente_id] = @cliente.id
        format.html { redirect_to :back}
        format.json { render :json => @cliente, :status => :created, :location => @cliente }
      else
        @titulo_pagina = "Nuevo Cliente"
        @accion = "registrar"
        flash[:mensaje] = "#{@cliente.errors.count} error(es) impiden que el cliente sea registrado: #{@cliente.errors.full_messages.join(". ")}."
        session[:cliente_id] = nil
        format.html { redirect_to :back }
        format.json { render :json => @cliente.errors, :status => :unprocessable_entity }
      end
    end
  end

  def registrar_jquery
    cliente = {:rif => "V-146237812-1", :razon_social => "Jackeline Contreras ", :domicilio => "Caracas"}
    @cliente = Cliente.new(cliente)
    if @cliente.save
      flash[:mensaje] = 'Cliente registrado'
    else
      flash[:mensaje] = "Cliente no registrado"
      return
    end
  end

  def actualizar
    @cliente = Cliente.find(params[:id])

    respond_to do |format|
      if @cliente.update_attributes(params[:cliente])
        flash[:mensaje] = 'Cliente actualizado'
        format.html { redirect_to :action => 'index'}
        format.json { head :ok }
      else
        @titulo_pagina = "Edicción de Cliente"
        @accion = "actualizar"
        format.html { render :action => "editar" }
        format.json { render :json => @cliente.errors, :status => :unprocessable_entity }
      end
    end
  end


  # def eliminar
  #   @cliente = Cliente.find(params[:id])
  #   @cliente.destroy

  #   respond_to do |format|
  #     format.html { redirect_to clientes_url }
  #     format.json { head :ok }
  #   end
  # end
end
