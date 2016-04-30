class ExamenTieneSegmento < ActiveRecord::Base

	attr_accessible :examen_id, :segmento_id, :cantidad_preguntas, :valor_pregunta

	belongs_to :examen
	belongs_to :segmento
end
