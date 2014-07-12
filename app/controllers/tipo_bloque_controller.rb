class TipoBloqueController < ApplicationController
	before_filter :filtro_logueado
 	before_filter :filtro_administrador

 	def nuevo
 		@tipo_bloque = TipoBloque.new
 		@tipo_dias = TipoDia.where("id != 'null'").order('orden')
 		# render :layout => false  
 	end

 	def nuevo_guardar
 		1/0
 		@tipo_ubicacion = TipoUbicacion.new (params[:tipo_ubicacion])
 		if @tipo_ubicacion.save
 			flash[:mensaje] = "Ubicación Agregada Satisfactoriamente"
 		else
 			flash[:mensaje] = "Error: #{@tipo_ubicacion.id}: #{@tipo_ubicacion.errors.full_messages.join(". ")}"
 		end
 		redirect_to :controller => 'admin_aula', :action => 'nuevo'
 	end
end
