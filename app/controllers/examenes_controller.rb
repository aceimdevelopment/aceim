# encoding: utf-8

class ExamenesController < ApplicationController

  before_filter :filtro_logueado
  before_filter :filtro_administrador

  # GET /examenes
  # GET /examenes.json
  def index
    @examenes = Examen.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @examenes }
    end
  end
  
  # GET /examenes/1
  # GET /examenes/1.json
  def show
    @examen = Examen.find(params[:id])

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

    respond_to do |format|
      if @examen.update_attributes(params[:examen])
        format.html { redirect_to @examen, :notice => 'Examen was successfully updated.' }
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
end
