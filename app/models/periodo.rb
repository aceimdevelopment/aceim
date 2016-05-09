# encoding: utf-8

#creada por db2models
class Periodo < ActiveRecord::Base
	PERIODO_TRANSICION_NOTAS_PARCIALES = "A-2016"


	def self.lista_ordenada
		Periodo.all.collect{|x| x}.sort_by{|x| "#{x.ano} #{x.id}"}.reverse()
	end

	def ordenado
		ident,ano = id.split("-")
		"#{ano}-#{ident}"		
	end

	def es_menor_que? periodo2_id
		es_menor = false

		ident,ano = id.split("-")
		ident2,ano2 = periodo2_id.split("-")

		if ano2 > ano
			es_menor = true
		elsif ano2.eql? ano
			es_menor = true if ident2 > ident
		end 
		return es_menor
	end

end
