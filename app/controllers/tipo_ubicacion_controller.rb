class TipoUbicacionController < ApplicationController
	before_filter :filtro_logueado
 	before_filter :filtro_administrador

 	def nuevo
 		@tipo_ubicacion = TipoUbicacion.new
 		render :layout => false  
 	end

 	def nuevo_guardar
 		
 		@tipo_ubicacion = TipoUbicacion.new (params[:tipo_ubicacion])
 		if @tipo_ubicacion.save
 			flash[:mensaje] = "Ubicación Agregada Satisfactoriamente"
 		else
 			flash[:mensaje] = "Error: #{@tipo_ubicacion.id}: #{@tipo_ubicacion.errors.full_messages.join(". ")}"
 		end
 		redirect_to :controller => 'admin_aula', :action => 'nuevo'
 	end
end