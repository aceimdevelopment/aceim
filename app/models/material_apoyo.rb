

class MaterialApoyo < ActiveRecord::Base
# ATRIBUTOS ACCESIBLES 
	attr_accessible :id, :nombre, :url, :tipo_material_apoyo_id

# ASOCIACIONES
	has_many :material_apoyo_cursos, :dependent => :destroy, :foreign_key => :material_apoyo_id
	accepts_nested_attributes_for :material_apoyo_cursos

	belongs_to :tipo_material_apoyo,
		:foreign_key => :tipo_material_apoyo_id


end
