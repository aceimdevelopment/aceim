class AdministradorController < ApplicationController
	before_filter :filtro_logueado
 	before_filter :filtro_administrador

	def index
		@administradores = Administrador.where("tipo_rol_id <> ? OR tipo_rol_id IS NULL", 2)
	end

	def editar
		ci = params[:parametros][:id]
  		@administrador = Administrador.where(:usuario_ci => ci).limit(1).first
  		render :layout => false  
	end

	def editar_guardar
		administrador = Administrador.where(:usuario_ci  => params[:administrador][:id]).limit(1).first
		administrador.tipo_rol_id = params[:administrador][:tipo_rol_id]
		
		if administrador.save
			flash[:mensaje] = "Actualización Correcta"
		else
			flash[:mensaje] = "No se pudo actualizar"
		end

		redirect_to :action => "index"
	end

	def eliminar
		administrador = Administrador.where(:usuario_ci => params[:ci]).limit(1).first
		administrador.destroy
		flash[:mensaje] = "Usuario Adminstrador Eliminado Correctamente"
		redirect_to :action => 'index'
	end

end