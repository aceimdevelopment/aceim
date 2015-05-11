class IdiomaCategoria < ActiveRecord::Base

	belongs_to :idioma
	belongs_to :tipo_categoria	

end
