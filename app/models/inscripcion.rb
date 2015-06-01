class Inscripcion < ActiveRecord::Base
	attr_accessible :tipo_inscripcion_id, :idioma_id, :tipo_categoria_id, :permitir_cambio_horario, :apertura, :cierre, :tipo_estado_inscripcion_curso_id
 	set_primary_keys [:tipo_inscripcion_id, :idioma_id, :tipo_categoria_id]

	belongs_to :tipo_inscripcion

	belongs_to :tipo_estado_inscripcion_curso

	belongs_to :tipo_curso,
    :foreign_key => ['idioma_id','tipo_categoria_id']

	validates :apertura, :presence => { :message => "Debe incluir el momento de apertura" }
	validates :cierre, :presence => {:message => "Debe incluir el momento de cierre"}

	validate :apertura_menorque_cierre


	def abierta?
		tipo_estado_inscripcion_curso_id.eql? 'AB'		
	end

	def cerrada?
		tipo_estado_inscripcion_curso_id.eql? 'CE'
	end

	def abrir_ahora?
		ahora = DateTime.now
		tipo_estado_inscripcion_curso_id.eql? 'PR' and
		(apertura.year.eql? ahora.year) and 
		(apertura.month.eql? ahora.month) and 
		(apertura.day.eql? ahora.day) and 
		(apertura.hour.eql? ahora.hour) and 
		(apertura.min.eql? ahora.min)

	end

	def cerrar_ahora?
		ahora = DateTime.now
		tipo_estado_inscripcion_curso_id.eql? 'AB' and
		(cierre.year.eql? ahora.year) and 
		(cierre.month.eql? ahora.month) and 
		(cierre.day.eql? ahora.day) and 
		(cierre.hour.eql? ahora.hour) and 
		(cierre.min.eql? ahora.min)

	end

    def descripcion
    	"#{tipo_curso.descripcion} - #{tipo_inscripcion.descripcion}"
    end

private

	def apertura_menorque_cierre
	    errors.add(:apertura, "- El Cierre debe ser después que Apertura") if
	        apertura > cierre
	end 
end