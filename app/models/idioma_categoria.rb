class IdiomaCategoria < ActiveRecord::Base

	set_primary_keys [:idioma_id, :tipo_categoria_id]

	belongs_to :idioma
	belongs_to :tipo_categoria	

	def descripcion
		"#{idioma.descripcion} (#{tipo_categoria.descripcion})"
	end

end
