# encoding: utf-8

class DetalleFactura < ActiveRecord::Base
	attr_accessible :factura_codigo, :periodo_id , :idioma_id , :tipo_categoria_id , :tipo_nivel_id, :cantidad, :total, :costo_unitario, :descripcion

	set_primary_keys :factura_codigo, :periodo_id , :idioma_id , :tipo_categoria_id , :tipo_nivel_id

	belongs_to :factura,
		:class_name => 'Factura',
		:foreign_key => 'factura_codigo'


	belongs_to :curso_periodo,
		:class_name => 'CursoPeriodo',
		:foreign_key => ['periodo_id' , 'idioma_id' , 'tipo_categoria_id' , 'tipo_nivel_id']

	validates_presence_of :factura_codigo, :periodo_id , :idioma_id , :tipo_categoria_id , :tipo_nivel_id

	validates :factura_codigo, :uniqueness => {:scope => ['periodo_id' , 'idioma_id' , 'tipo_categoria_id' , 'tipo_nivel_id']}
end