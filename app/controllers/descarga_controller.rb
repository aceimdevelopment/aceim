class DescargaController < ApplicationController
	before_filter :filtro_logueado


	def syllabus
		ha = HistorialAcademico.where(:idioma_id => 'IN', :usuario_ci => session[:usuario].ci, :tipo_categoria_id => 'AD', :periodo_id => ParametroGeneral.periodo_actual.id).first
		if (params[:nivel] and ha and (params[:nivel].include? ha.tipo_nivel_id)) or session[:administrador]

			case params[:nivel]
			when "BI" 
				archivo = "BI_American Cutting Edge.pdf"
			when "BII" 
				archivo = "BII_American Cutting Edge.pdf"
			when "BIII" 
				archivo = "BIII_American Cutting Edge.pdf"
			when "CB-S" 
				archivo = "BASIC CONV_Sabados.pdf"
			when "CB"
				archivo = "BASIC CONV_WEEK DAYS.pdf"
			when "MI" 
				archivo = "INT I_American Cutting Edge.pdf"
			when "MII" 
				archivo = "INT II_American Cutting Edge.pdf"
			when "MIII" 
				archivo = "INT_III American Cutting Edge.pdf"
			when "CI-S" 
				archivo = "INT CONV_Sabados.pdf"
			when "CI" 
				archivo = "INT CONV_WEEK DAYS.pdf"
			when "AI" 
				archivo = "ADV I_ Summit.pdf"
			when "AII" 
				archivo = "ADV II_ Summit.pdf"
			when "AIII" 
				archivo = "ADV III_Summit.pdf"
			when "CA" 
				archivo = "ADV CONV.pdf"
			end

			if archivo
				send_file "#{Rails.root}/attachments/syllabus/#{archivo}", :type => "application/pdf", :x_sendfile => true, :disposition => "attachment"
			else
				flash[:mensaje] = "Nivel de curso sin Syllabus."	
				redirect_to :back
			end
		else
		    flash[:mensaje] = "No hay Syllabus disponibles para ud."
		    redirect_to :back
    	end		
	end


	# def syllabus

	# 	if ha  = HistorialAcademico.where(:idioma_id => 'IN', :usuario_ci => session[:usuario].ci, :tipo_categoria_id => 'AD', :periodo_id => ParametroGeneral.periodo_actual.id).first
	# 		case ha.tipo_nivel_id
	# 		when "BI" 
	# 			archivo = "BI_American Cutting Edge.pdf"
	# 		when "BII" 
	# 			archivo = "BII_American Cutting Edge.pdf"
	# 		when "BIII" 
	# 			archivo = "BIII_American Cutting Edge.pdf"
	# 		when "CB" 
	# 			# casos especiales
	# 			if ha.seccion.bloque_horario.id.eql? 'H5'
	# 				archivo = "BASIC CONV_Sabados.pdf"
	# 			else
	# 				archivo = "BASIC CONV_WEEK DAYS.pdf"
	# 			end
	# 		when "MI" 
	# 			archivo = "INT I_American Cutting Edge.pdf"
	# 		when "MII" 
	# 			archivo = "INT II_American Cutting Edge.pdf"
	# 		when "MIII" 
	# 			archivo = "INT_III American Cutting Edge.pdf"
	# 		when "CI" 
	# 			# casos especiales
	# 			if ha.seccion.bloque_horario.id.eql? 'H5'
	# 				archivo = "INT CONV_Sabados.pdf"
	# 			else
	# 				archivo = "INT CONV_WEEK DAYS.pdf"
	# 			end
	# 		when "AI" 
	# 			archivo = "ADV I_ Summit.pdf"
	# 		when "AII" 
	# 			archivo = "ADV II_ Summit.pdf"
	# 		when "AIII" 
	# 			archivo = "ADV III_Summit.pdf"
	# 		when "CA" 
	# 			archivo = "ADV CONV.pdf"
	# 		end

	# 		if archivo
	# 			send_file "#{Rails.root}/attachments/syllabus/#{archivo}", :type => "application/pdf", :x_sendfile => true, :disposition => "attachment"
	# 		else
	# 			flash[:mensaje] = "Nivel de curso sin Syllabus."	
	# 			redirect_to :back
	# 		end
	# 	else
	# 	    flash[:mensaje] = "No hay Syllabus disponibles para ud."
	# 	    redirect_to :back
 #    	end
	# end
end