# encoding: utf-8

class TipoSegmentosController < ApplicationController
  # GET /tipo_segmentos
  # GET /tipo_segmentos.json
  def index
    @tipo_segmentos = TipoSegmento.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @tipo_segmentos }
    end
  end

  # GET /tipo_segmentos/1
  # GET /tipo_segmentos/1.json
  def show
    @tipo_segmento = TipoSegmento.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @tipo_segmento }
    end
  end

  # GET /tipo_segmentos/new
  # GET /tipo_segmentos/new.json
  def new
    @tipo_segmento = TipoSegmento.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @tipo_segmento }
    end
  end

  # GET /tipo_segmentos/1/edit
  def edit
    @tipo_segmento = TipoSegmento.find(params[:id])
  end

  # POST /tipo_segmentos
  # POST /tipo_segmentos.json
  def create
    @tipo_segmento = TipoSegmento.new(params[:tipo_segmento])

    respond_to do |format|
      if @tipo_segmento.save
        format.html { redirect_to @tipo_segmento, :notice => 'Tipo segmento was successfully created.' }
        format.json { render :json => @tipo_segmento, :status => :created, :location => @tipo_segmento }
      else
        format.html { render :action => "new" }
        format.json { render :json => @tipo_segmento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tipo_segmentos/1
  # PUT /tipo_segmentos/1.json
  def update
    @tipo_segmento = TipoSegmento.find(params[:id])

    respond_to do |format|
      if @tipo_segmento.update_attributes(params[:tipo_segmento])
        format.html { redirect_to @tipo_segmento, :notice => 'Tipo segmento was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @tipo_segmento.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tipo_segmentos/1
  # DELETE /tipo_segmentos/1.json
  def destroy
    @tipo_segmento = TipoSegmento.find(params[:id])
    @tipo_segmento.destroy

    respond_to do |format|
      format.html { redirect_to tipo_segmentos_url }
      format.json { head :ok }
    end
  end
end
