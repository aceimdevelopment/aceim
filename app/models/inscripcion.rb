class Inscripcion < ActiveRecord::Base
	attr_accessible :tipo_inscripcion_id, :idioma_id, :tipo_categoria_id, :permitir_cambio_horario, :apertura, :cierre, :tipo_estado_inscripcion_curso_id, :apertura_entrega_planilla, :cierre_entrega_planilla
 	set_primary_keys [:tipo_inscripcion_id, :idioma_id, :tipo_categoria_id]

	belongs_to :tipo_inscripcion

	belongs_to :tipo_estado_inscripcion_curso

	belongs_to :tipo_curso,
    :foreign_key => ['idioma_id','tipo_categoria_id']

	validates :apertura, :presence => { :message => "Debe incluir el momento de apertura" }
	validates :cierre, :presence => {:message => "Debe incluir el momento de cierre"}

	# validates :apertura_entrega_planilla, :presence => { :message => "Debe incluir el momento de entrega de planilla" }
	# validates :cierre_entrega_planilla, :presence => {:message => "Debe incluir el momento de cierre de entrega de planilla"}

	validate :apertura_menorque_cierre

	def ninos_abierta?
		tipo_estado_inscripcion_curso_id.eql? 'AB' and tipo_categoria_id.eql? 'NI'
	end

	def nuevos?
		tipo_inscripcion_id.eql? 'NU'
	end

	def regulares?
		tipo_inscripcion_id.eql? 'RE'
	end

	def regulares_o_nuevos?
		tipo_inscripcion_id.eql? 'NU' or tipo_inscripcion_id.eql? 'RE'
	end

	def cambio_horario?
		tipo_inscripcion_id.eql? 'CA'
	end

	def nuevo_abierta?
		tipo_estado_inscripcion_curso_id.eql? 'AB' and tipo_inscripcion.eql? 'NU'
	end

	def abierta?
		tipo_estado_inscripcion_curso_id.eql? 'AB'		
	end

	def cerrada?
		tipo_estado_inscripcion_curso_id.eql? 'CE'
	end

	def abrir_ahora?
		tipo_estado_inscripcion_curso_id.eql? 'PR' and apertura <= DateTime.now
	end

	def cerrar_ahora?
		tipo_estado_inscripcion_curso_id.eql? 'AB' and cierre <= DateTime.now
	end

    def descripcion
    	"#{tipo_curso.descripcion} - #{tipo_inscripcion.descripcion}"
    end

private

	def apertura_menorque_cierre
	    errors.add(:apertura, "- El Cierre debe ser después que la Apertura") if
	        apertura > cierre
	end 
end