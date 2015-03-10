#creada por db2models
class Periodo < ActiveRecord::Base

	def ordenado
		ident,ano = id.split("-")
		"#{ano}-#{ident}"		
	end

end
