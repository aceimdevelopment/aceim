class AdministradorController < ApplicationController
	before_filter :filtro_logueado
 	before_filter :filtro_administrador

	def index
		@administradores = Administrador.all
	end

	def editar
		ci = params[:parametros][:id]
  		@administrador = Administrador.where(:usuario_ci => ci).limit(1).first
  		render :layout => false  
	end

	def editar_guardar
		administrador = Administrador.where(:usuario_ci  => params[:administrador][:id]).limit(1).first
		administrador.rol = params[:administrador][:rol]
		
		if administrador.save
			flash[:mensaje] = "Actualización Correcta"
		else
			flash[:mensaje] = "No se pudo actualizar"
		end

		redirect_to :action => "index"

	end

end