#creada por db2models
class Periodo < ActiveRecord::Base
	PERIODO_TRANSICION_NOTAS_PARCIALES = "A-2016"

	PERIODO_30 = "D-2016"

	has_many :archivos
	accepts_nested_attributes_for :archivos


	def id_reverso
		self.id.split("-").reverse.join("-")
	end

	def letra
		id.split("-").first
	end

	def periodo_anterior
		pes = Periodo.lista_ordenada
		indice = pes.index self
		indice += 1

		if (indice >= pes.size)
			return nil
		else
			return pes[indice]
		end

	end

	def self.lista_ordenada
		Periodo.order([:ano, :id]).reverse
	end

	def ordenado
		ident,ano = id.split("-")
		"#{ano}-#{ident}"		
	end

	def es_mayor_igual_que? periodo4_id
		es_mayor_que? periodo4_id
	end

	def es_mayor_que? periodo3_id
		not es_menor_que? periodo3_id
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
