# encoding: utf-8

class TipoSegmento < ActiveRecord::Base

	attr_accessible :id, :nombre

	belongs_to :segmentos,
	:foreign_key => :tipo_segmento_id

end