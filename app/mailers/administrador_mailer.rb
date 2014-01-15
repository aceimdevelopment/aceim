class AdministradorMailer < ActionMailer::Base
  default :from => "fundeim@ucv.ve"
  
  def enviar_notificacion(instructores)
    @instructores = instructores
    # aleidajave@yahoo.com   
    #joyce Gutiérrez Juárez <joygutierrez@hotmail.com>
    #carlos A. Saavedra A. <saavedraazuaje73@gmail.com>
    #sergiorivas@gmail.com,
    mail(:to => 'aleidajave@yahoo.com',
         :bcc => 'joygutierrez@hotmail.com,saavedraazuaje73@gmail.com,luciusdaniel@gmail.com',
         :subject => "Notificación de Pago")
  end 
  
  def aviso_general(correo,titulo,info)
    @info = info
    mail(:to => correo, :subject => "Aviso General - #{titulo}")
  end
  
  def enviar_correo_general(para,asunto,mensaje,adjunto)
    @mensaje = mensaje
    if adjunto
      attachments.inline[adjunto] = File.read("#{Rails.root}/attachments/#{adjunto}")
    end
    mail(:to => para, :subject => asunto, :body => mensaje, :content_type => "multipart/mixed")
  end
  
end
