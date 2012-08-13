class EstudianteMailer < ActionMailer::Base
  default :from => "fundeimucv@gmail.com"      
  
  def bienvenida(usuario)
    @nombre = usuario.nombre_completo     
    @clave = usuario.contrasena
    attachments['folleto_inscripcion_C_2011.pdf'] = File.read("#{Rails.root}/attachments/folleto_inscripcion_C_2011.pdf")
    mail(:to => usuario.correo, :subject => "FUNDEIM Bienvenida - Proceso de Inscripción de los Cursos de Idiomas Modernos")
  end


  def recordatorio(usuario)
    @nombre = usuario.nombre_completo     
    @clave = usuario.contrasena   
    attachments['folleto_inscripcion_A_2012.pdf'] = File.read("#{Rails.root}/attachments/folleto_inscripcion_A_2012.pdf")
    mail(:to => usuario.correo, :subject => "Inscripción de los Cursos de Idiomas Modernos")
  end

  def cambio_aulas_faces(usuario,seccion)
    @nombre = usuario.nombre_completo
    @seccion = seccion
    attachments['cambio_salones_sabado.pdf'] = File.read("#{Rails.root}/attachments/cambio_salones_sabado.pdf")
    mail(:to => usuario.correo, :subject => "FUNDEIM - Cambio de aula de la sección: #{seccion.descripcion}")
  end

  def olvido_clave(usuario)
    @nombre = usuario.nombre_completo
    @clave = usuario.contrasena
    mail(:to => usuario.correo, :subject => "FUNDEIM - Recordatorio de clave")
  end

end
