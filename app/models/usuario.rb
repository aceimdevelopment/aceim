#creada por db2models
class Usuario < ActiveRecord::Base
	
	include ActiveModel::Validations    
	attr_accessor :contrasena_confirmation
  attr_accessible :ci,:nombres, :apellidos, :contrasena, :telefono_movil, :correo, :tipo_sexo_id, :fecha_nacimiento
  #autogenerado por db2models
  set_primary_key :ci
  #autogenerado por db2models
  has_one :estudiante,
    :primary_key => :usuario_ci,  
    :foreign_key => 'usuario_ci'

  has_one :administrador,
    :foreign_key => ['ci']

  has_one :instructor,
    :foreign_key => ['ci']

  belongs_to :tipo_sexo,
    :class_name => 'TipoSexo',
    :foreign_key => ['tipo_sexo_id']

  has_many :historiales_academicos,
    :class_name => 'HistorialAcademico',
    :foreign_key => [:usuario_ci]

  has_many :estudiante_cursos,
    :class_name => 'EstudianteCurso',
    :foreign_key => ['usuario_ci']


  has_many :nivelaciones,
    :class_name => 'EstudianteNivelacion',
    :foreign_key => ['usuario_ci']
  accepts_nested_attributes_for :nivelaciones


  validates :ci, :presence => true,  
                 :uniqueness => true
                 
                # ,
                # :numericality => { :only_integer => true, 
                #                    :greater_than => 1000, 
                #                    :less_than => 100000000  }, 
                # :ci => true           
                 
  validates :nombres,  :presence => true
  validates :apellidos, :presence => true  
  #validates :fecha_nacimiento, :presence => true  
  validates :contrasena, :presence => true  
  validates :telefono_movil, :tlf => true	
  validates :correo, :presence => true, :email => true
  validates :tipo_sexo_id, :presence => true
  validates :contrasena, :confirmation => true
  validates :contrasena, :length => 5..30

  def self.autenticar(login,clave)
    usuario = Usuario.where(:ci => login, :contrasena => clave,:activo => true).limit(1).first
  end    
  
  def edad
    edad = Time.now.year - fecha_nacimiento.year
    edad -= 1 if Date.today < fecha_nacimiento + edad.years 
    edad
  end    
  
  def descripcion_con_datos_contacto
    "#{nombre_completo} - #{datos_contacto}"
  end

  def nombre_completo
    "#{apellidos} #{nombres}"
  end 
  
  def administrador
    Administrador.where(:usuario_ci => ci).limit(1).first
  end

  def instructor
    Instructor.where(:usuario_ci => ci).limit(1).first
  end           

  def estudiante
    Estudiante.where(:usuario_ci => ci).limit(1).first
  end           
     
  def estudiante_curso
    EstudianteCurso.where(:usuario_ci => ci)
  end
  
  def descripcion
    "#{apellidos} #{nombres}, (#{ci})"
  end
  
  def datos_contacto
    "#{telefono_movil}, #{correo}"
  end
  
  def eliminar_total
    administrador.destroy if administrador
    instructor.destroy if instructor
    estudiante.destroy if estudiante
  end

  def estado_bloqueo
    activo ? "Activado" : "Bloqueado"
  end

end
