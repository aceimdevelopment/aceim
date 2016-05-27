# encoding: utf-8

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
		@periodos = Periodo.lista_ordenada
	end

	def generar
		@examen = Examen.new(params[:examen])

		respond_to do |format|
			if @examen.save
				exito = 0
				 Parte.order('orden ASC').all.each do |parte|
					exito += 1 if @examen.parte_examenes.create(:parte_id => parte.id)  
				end	
				resultado_bloques = "#{exito} Partes del examen añadidas."
				flash[:mensaje] = "Datos básicos almacenados con éxito.#{resultado_bloques}"
				format.html { redirect_to :action => 'wizard_paso2', :id => @examen.id}
				format.json { render :json => @examen, :status => :created, :location => @examen }
			else
				@titulo = "Nueva Examen"
				@accion = "registrar"
				@idiomas = Idioma.all.delete_if{|i| i.id.eql? 'OR'}
				@categorias = TipoCategoria.all.delete_if{|cat| ['BBVA','TR'].include? cat.id}
				@niveles = TipoNivel.where(:id => ['BI','BII','BIII','MI','MII','MIII','AI','AII','AIII'])
				@periodos = Periodo.lista_ordenada		
				flash[:mensaje] = "#{@examen.errors.count} error(es) impiden el registro de la factura: #{@examen.errors.full_messages.join(". ")}."
				format.html { render :action => "wizard_paso1" }
				format.json { render :json => @factura.errors, :status => :unprocessable_entity }
			end
		end

	end

	def wizard_paso2
		id = params[:id]
		@titulo = "Nuevo Examen"
		@examen = Examen.find(id)
		@actividad = Actividad.new

	end


	def previsualizar
		id = params[:id]
		@titulo = "Vista Previa del Examen"
		@examen = Examen.find(id)
		@host = "#{request.protocol}#{request.host_with_port}/aceim/assets/examenes/"
		
	end

	def eliminar_pregunta
		@pregunta = Pregunta.find(params[:id])
		@actividad = @pregunta.actividad
		@pregunta.destroy
		redirect_to :back
    	# render :partial => "preguntas/preguntas_text", :locals => {:actividad => @actividad}
	end

	def registrar_actividad
		@parte_examen = (ParteExamen.where (params[:parte_examen])).limit(1).first

		if @parte_examen

			@actividad = Actividad.new(params[:actividad])
			if @actividad.save and @parte_examen.parte_examen_actividades.create(:actividad_id => @actividad.id)
				flash[:mensaje] = "Actividad agregar con éxito"
			else
				flash[:mensaje] = "No se pudo agregar la actividad. Por favor verifique los campos e intentelo nuevamente."
			end
		else
			flash[:mensaje] = "Falló la inclusión de la nueva actividad, No se encontró la parte del examen requerida. Por Favor Verifique e intentelo nuevamente."
		end
		
		redirect_to :action => 'wizard_paso2', :id => "#{params[:parte_examen][:examen_id]}"
	end

	def actualizar_actividad
		@actividad = Actividad.find(params[:id])
		if @actividad.update_attributes(params[:actividad])
			flash[:mensaje] = "Datos elementales de la actividad actualizados"
		else
			flash[:mensaje] = "No se pudo actualizar los datos de la actividad"
		end
		redirect_to :back
	end

	def eliminar_actividad
		@actividad = Actividad.find(params[:id])
		flash[:mensaje] = "Actividad Eliminada con éxito" if @actividad.destroy

		redirect_to :back
	end

	def eliminar_examen
		@examen = Examen.find(params[:id])
		@examen.destroy
		flash[:mensaje] = "Examen Eliminado con éxito" if @examen.destroy		

		redirect_to :action => 'wizard_paso1'
		# render :partial => "actividads/wizard_list", :locals => {:examen => @examen}
	end

end
