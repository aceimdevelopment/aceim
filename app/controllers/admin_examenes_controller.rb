class AdminExamenesController < ApplicationController

	before_filter :filtro_logueado
	before_filter :filtro_administrador
  	skip_before_filter  :verify_authenticity_token  
	
	def index
		@cursos = Curso.order(['idioma_id', 'grado']).all
		@titulo = "Examentes Listados por Curso"
	end

	def wizard_paso1
		@titulo = 'Nuevo Examen'
		@examen = Examen.new
		@idiomas = Idioma.all.delete_if{|i| i.id.eql? 'OR'}
		@categorias = TipoCategoria.all.delete_if{|cat| ['BBVA','TR'].include? cat.id}
		@niveles = TipoNivel.where(:id => ['BI','BII','BIII','MI','MII','MIII','AI','AII','AIII'])
		@periodos = Periodo.all.collect{|x| x}.sort_by{|x| "#{x.ano} #{x.id}"}.reverse()
	end

	def generar
		
		@examen = Examen.new(params[:examen])

		respond_to do |format|
			if @examen.save
				flash[:mensaje] = 'Datos básicos almacenados con éxito.'
				format.html { redirect_to :action => 'wizard_paso2', :id => @examen.id}
				format.json { render :json => @examen, :status => :created, :location => @examen }
			else
				@titulo_pagina = "Nueva Examen"
				@accion = "registrar"
				@idiomas = Idioma.all.delete_if{|i| i.id.eql? 'OR'}
				@categorias = TipoCategoria.all.delete_if{|cat| ['BBVA','TR'].include? cat.id}
				@niveles = TipoNivel.where(:id => ['BI','BII','BIII','MI','MII','MIII','AI','AII','AIII'])
				
				flash[:mensaje] = "#{@examen.errors.count} error(es) impiden el registro de la factura: #{@examen.errors.full_messages.join(". ")}."
				format.html { render :action => "wizard_paso1" }
				format.json { render :json => @factura.errors, :status => :unprocessable_entity }
			end
		end

	end

	def wizard_paso2

		id = params[:id]

		@examen = Examen.find(id)


	end

	def eliminar_pregunta
		@pregunta = Pregunta.find(params[:id])
		@segmento = @pregunta.segmento
		@pregunta.destroy
		redirect_to :back
    	# render :partial => "preguntas/preguntas_text", :locals => {:segmento => @segmento}
	end

	def eliminar_segmento
		@segmento = Segmento.find(params[:id])
		@examen = @segmento.examen
		@segmento.destroy
		redirect_to :back
		# render :partial => "segmentos/wizard_list", :locals => {:examen => @examen}
	end

	def eliminar_examen
		@segmento = Examen.find(params[:id])
		@segmento.destroy
		redirect_to :action => 'wizard_paso1'
		# render :partial => "segmentos/wizard_list", :locals => {:examen => @examen}
	end
end
