#creada por db2models
class TipoCategoria < ActiveRecord::Base
	
	def complemento
  	return "(#{descripcion})" if id !="AD"
    return ""
  end


  

end
