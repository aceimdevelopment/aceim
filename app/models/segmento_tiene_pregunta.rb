class SegmentoTienePregunta < ActiveRecord::Base

	belongs_to :pregunta
	belongs_to :segmento

end
