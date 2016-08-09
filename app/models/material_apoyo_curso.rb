

class MaterialApoyoCurso < ActiveRecord::Base
# ATRIBUTOS ACCESIBLES 
	attr_accessible :material_apoyo_id, :curso_idioma_id, :curso_tipo_categoria_id, :curso_tipo_nivel_id


# CLAVE PRIMARIA CONPUESTA
	set_primary_keys [:material_apoyo_id, :curso_idioma_id, :curso_tipo_categoria_id, :curso_tipo_nivel_id]

#ASOCIACIONES
	
	belongs_to :material_apoyo

	belongs_to :curso	
	
end
