class UserMailer < ActionMailer::Base
  default from: "contacto@corobook.com"

  def invited_collaborator(creador, user)
    @user = user
    @creador = creador
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Te cree una cuenta en Corobook")
  end

  def send_songbook(songbook,user)
    @user = user
    @songbook = songbook
    
    mail(:to => "#{user.name} <#{user.email}>", :subject => "Coros para el" + songbook.fecha.strftime('%e/%m/%Y'))

  end

end
