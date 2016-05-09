# encoding: utf-8

class SegmentoTienePregunta < ActiveRecord::Base

	belongs_to :pregunta
	belongs_to :segmento

end
