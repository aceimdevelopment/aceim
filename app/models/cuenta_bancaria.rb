# encoding: utf-8

#creada por db2models
class CuentaBancaria < ActiveRecord::Base

	has_many :historiales,
	:class_name => 'HistorialAcademico',
	:foreign_key => :cuenta_bancaria_id

	accepts_nested_attributes_for :historiales

	def descripcion

		"#{id} #{titular}"
		
	end

end
